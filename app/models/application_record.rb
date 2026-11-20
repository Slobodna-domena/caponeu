class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include Versioning

  def self.ransackable_associations(auth_object = nil)
    @ransackable_associations ||= reflect_on_all_associations.map { |a| a.name.to_s }
  end

  def self.ransackable_attributes(auth_object = nil)
    secure_column_names = column_names - ["encrypted_password", "reset_password_token", "password"]
    @ransackable_attributes ||= secure_column_names + _ransackers.keys + _ransack_aliases.keys + attribute_aliases.keys
  end


  def self.ai_search(question, ip_address: nil, excluded_records: [])
    return { results: [], rate_limited: false } if question.blank?

    if ip_address.present?
      unless AiSearchLog.can_search?(ip_address: ip_address)
        remaining = AiSearchLog.remaining_searches(ip_address: ip_address)
        AiSearchLog.log_rate_limit_exceeded(ip_address)
        return {
          results: [],
          rate_limited: true,
          remaining_searches: remaining
          }
        end
        AiSearchLog.create(
          query: question.truncate(AI_SEARCH_CONFIG[:query_max_length]),
          ip_address: ip_address
        )
    end

    begin
      endpoint = Rails.env.development? ? "http://localhost:8000/query" : "http://llm.caponeu.eu/query"

      response = HTTParty.post(
        endpoint,
        body: { question: question }.to_json,
        headers: { 'Content-Type' => 'application/json' },
        timeout: AI_SEARCH_CONFIG[:request_timeout]
      )

      raw_answer = response.parsed_response["answer"]
      return { results: [], rate_limited: false } if raw_answer.blank? || raw_answer == "Null"

      parsed_records = []

      raw_answer.scan(/\(ID:\s*(\d+),\s*table:\s*'(\w+)'\)/i).each do |id_str, table|
        id = id_str.to_i

        begin
          model_class = table.singularize.capitalize.constantize
          record = model_class.find_by(id: id)
          next unless record

          begin
            if model_class && model_class.name == "Keyword"
              parsed_records << {
                id: record.id,
                model: model_class.name,
                url: Rails.application.routes.url_helpers.url_for(
                  controller: "topic",
                action: :show,
                id: record.respond_to?(:slug) ? record.slug : record.id,
                only_path: true
                ),
                record: record
              }
            else
              parsed_records << {
                id: record.id,
                model: model_class.name,
                url: Rails.application.routes.url_helpers.url_for(
                  controller: model_class.name.downcase,
                action: :show,
                id: record.respond_to?(:slug) ? record.slug : record.id,
                only_path: true
                ),
                record: record
              }
            end
          rescue => e
            next
          end
        rescue NameError => e
          next
        rescue => e
          next
        end
      end

      { results: parsed_records, rate_limited: false }
    rescue => e
      Rails.logger.error "Greška: #{e.message}"
      []
    end
  end
end
