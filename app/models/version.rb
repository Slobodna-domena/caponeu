class Version < PaperTrail::Version
  self.table_name = "versions"

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      item_type
      item_id
      event
      whodunnit
      created_at
      object
      object_changes
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def parsed_metadata
    @parsed_metadata ||= begin
        if metadata.present?
          JSON.parse(metadata)
        else
          {}
        end
      rescue JSON::ParserError
        {}
      end
  end

  # def ip
  #   parsed_metadata.dig('ip')
  # end

  def user_agent
    parsed_metadata.dig("user_agent")
  end
end
