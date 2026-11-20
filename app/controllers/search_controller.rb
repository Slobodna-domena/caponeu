class SearchController < ApplicationController
  def global_search
    items_per_page = 9
    @query = params[:title].to_s.strip

    if @query.present?
      @novels = Novel.where("unaccent(title) ILIKE unaccent(?) or unaccent(english_title) ILIKE unaccent(?) or unaccent(slug) ILIKE unaccent(?)", "%#{@query}%", "%#{@query}%", "%#{@query}%")
      @materials = Material.where("unaccent(title) ILIKE unaccent(?)", "%#{@query}%")
      @events = Event.where("unaccent(title) ILIKE unaccent(?)", "%#{@query}%")
      @types = PersonType.where(hide_from_people_directory: [nil, false]).order(:label)
      @people = Person.joins(:person_types).where(person_types: { id: @types.pluck(:id) }).distinct.where("unaccent(CONCAT_WS(' ', first_name, last_name)) ILIKE unaccent(?)", "%#{@query}%")
      @organizations = Organization.where("unaccent(label) ILIKE unaccent(?)", "%#{@query}%")
      @topics = Keyword.where("unaccent(label) ILIKE unaccent(?)", "%#{@query}%")
      @topics = @topics.reject { |topic| topic.novels.length == 0 }.then { |a| Kaminari.paginate_array(a) }

      @novels_count = @novels.count
      @materials_count = @materials.count
      @events_count = @events.count
      @people_count = @people.count
      @organizations_count = @organizations.count
      @topics_count = @topics.count

      @novels = @novels.page(params[:page]).per(items_per_page)
      @materials = @materials.page(params[:page]).per(items_per_page)
      @events = @events.page(params[:page]).per(items_per_page)
      @people = @people.page(params[:page]).per(items_per_page)
      @organizations = @organizations.page(params[:page]).per(items_per_page)
      @topics = @topics.page(params[:page]).per(items_per_page)

      @has_results = @novels.any? || @materials.any? || @events.any? || @people.any? || @organizations.any? || @topics.any?
    else
      @has_results = false
      @novels = []
      @materials = []
      @events = []
      @people = []
      @organizations = []
      @topics = []
    end

    if params[:title].present?
      if current_admin_user
        @ai_search_results = ApplicationRecord.ai_search(params[:title])[:results] || []
      else
        ip = request.remote_ip == "::1" ? "127.0.0.1" : request.remote_ip
        result = ApplicationRecord.ai_search(params[:title], ip_address: ip)
        @ai_search_results = result[:results] || []
      end
      merge_ai_results_into_collections if @ai_search_results.any?
    else
      @ai_search_results = []
    end

    @novels = @novels.to_a
    @materials = @materials.to_a
    @events = @events.to_a
    @people = @people.to_a
    @organizations = @organizations.to_a
    @topics = @topics.to_a

    @novels_count = @novels.count
    @materials_count = @materials.count
    @events_count = @events.count
    @people_count = @people.count
    @organizations_count = @organizations.count
    @topics_count = @topics.count

    @novels = Kaminari.paginate_array(@novels).page(params[:page]).per(items_per_page)
    @materials = Kaminari.paginate_array(@materials).page(params[:page]).per(items_per_page)
    @events = Kaminari.paginate_array(@events).page(params[:page]).per(items_per_page)
    @people = Kaminari.paginate_array(@people).page(params[:page]).per(items_per_page)
    @organizations = Kaminari.paginate_array(@organizations).page(params[:page]).per(items_per_page)
    @topics = Kaminari.paginate_array(@topics).page(params[:page]).per(items_per_page)

    @has_results = @novels.any? || @materials.any? || @events.any? || @people.any? || @organizations.any? || @topics.any?

    respond_to do |format|
      format.html
      format.json { render json: { results: {ai_search_results: @ai_search_results, novels: @novels, materials: @materials, events: @events, people: @people, organizations: @organizations, topics: @topics } } }
    end

    @site_title = "Search"
  end


  private

  def merge_ai_results_into_collections
    return unless @ai_search_results.present?
    novel_ids = @novels.pluck(:id).to_set
    material_ids = @materials.pluck(:id).to_set
    event_ids = @events.pluck(:id).to_set
    people_ids = @people.pluck(:id).to_set
    organization_ids = @organizations.pluck(:id).to_set
    topic_ids = @topics.respond_to?(:pluck) ? @topics.pluck(:id).to_set : @topics.map(&:id).to_set

    @ai_search_results.each do |ai_result|
      record = ai_result[:record]
      next unless record

      case ai_result[:model]
      when 'Novel'
        unless novel_ids.include?(record.id)
          @novels = [@novels, record].flatten
          novel_ids.add(record.id)
        end
      when 'Material'
        unless material_ids.include?(record.id)
          @materials = [@materials, record].flatten
          material_ids.add(record.id)
        end
      when 'Event'
        unless event_ids.include?(record.id)
          @events = [@events, record].flatten
          event_ids.add(record.id)
        end
      when 'Person'
        unless people_ids.include?(record.id)
          @people = [@people, record].flatten
          people_ids.add(record.id)
        end
      when 'Organization'
        unless organization_ids.include?(record.id)
          @organizations = [@organizations, record].flatten
          organization_ids.add(record.id)
        end
      when 'Keyword'
        unless topic_ids.include?(record.id)
          if record.novels.length > 0
            @topics = [@topics, record].flatten
            topic_ids.add(record.id)
          end
        end
      end
    end
  end
end
