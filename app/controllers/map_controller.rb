class MapController < ApplicationController
  def index
    @languages = Language.order(:label)
    @categories = Category.order(:label)
    @keywords = Keyword.order(:label)

    @places = fetch_places #fetch_places_for_type("novels")
    session[:map_items] = []
    @site_title = "Map"
    # render json: @places
  end

  def explore
    @item, related_type = find_item_and_type(params[:type], params[:slug])
    return unless @item

    @model_name = @item.class.name.downcase
    #@places = fetch_places_for_item(@item, related_type)
    result = fetch_related_novels(@item)
    @places = result[:locations]
    @matching_criteria = result[:matching_criteria]
    update_session_map_items(params[:type], @item.id, params[:index])
    @site_title = "Map"
    # render json: @places
  end

  private

  def find_item_and_type(type, slug)
    case type
    when "novel" then [Novel.find(slug), "all"]
    when "event" then [Event.find(slug), "novels"]
      #when "material" then [Material.find(slug), "novels"]
    else
      nil # Handle unknown type case as needed
    end
  end

  def update_session_map_items(type, item_id, index)
    # session[:map_items] = session[:map_items][0...index.to_i] if index
    session[:map_items] = [] unless session[:map_items]
    session[:map_items] << [type, item_id] unless index or session[:map_items].last == [type, item_id]
  end

  def fetch_places
    Novel.where.not(place_of_origin_id: nil).map do |novel|
      next unless novel.place_of_origin&.mappable?
      items = fetch_items_for_location(novel.place_of_origin, "novels", true)
      build_place(novel.place_of_origin, items) if items.any?
    end.compact.uniq
  end

  

  # def fetch_places_for_type(type)
  #   Geo.where.not(latitude: nil).map do |loc|
  #     items = fetch_items_for_location(loc, type)
  #     build_place(loc, items) if items.any?
  #   end.compact
  # end

  def fetch_places_for_item(item, related_type)
    related_types = related_type == "all" ? %w[related_events related_novels] : [related_type]
    related_types.flat_map { |type| fetch_places_for_related_type(item, type) }
  end

  def fetch_places_for_related_type(item, related_type)
    item.send(related_type).flat_map(&:geos).uniq.map do |loc|
      items = fetch_items_for_location(loc, related_type)
      related_items = []
      items.each do |i|
        related_items << i if item.send(related_type).pluck(:slug).include?(i[:slug]) and i[:location_ids].include?(loc.id)
      end
      build_place(loc, related_items)
    end.compact
  end

  def fetch_items_for_location(location, type, place_of_origin = false)
    origin_place = Novel.where(place_of_origin_id: location.id)
    items = place_of_origin ? origin_place : origin_place + location.send(type)
    
    items = items.where("novels.title ILIKE ? or novels.english_title ILIKE ? or novels.slug ILIKE ?", "%#{params[:title]}%", "%#{params[:title]}%", "%#{params[:title]}%") if params[:title].present?
    items = items.joins(:authors).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:author], params[:author], params[:author]) if params[:author].present?
    items = items.joins(:portrait_authors).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:portrait_author], params[:portrait_author], params[:portrait_author]) if params[:portrait_author].present?
    items = items.where("novels.from_year >= #{params[:from_year].to_i}") if params[:from_year].present?
    items = items.where("novels.from_year <= #{params[:to_year].to_i}") if params[:to_year].present?
    items = items.joins(:people).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:name], params[:name], params[:name]) if params[:name].present?
    items = items.joins(:organizations).where("label ILIKE '%" + params[:organization] + "%'") if params[:organization].present?
    items = items.joins(:categories).where(categories: { id: params[:category].to_i }) if params[:category].present?
    items = items.joins(:keywords).where(keywords: { id: params[:topic].to_i }) if params[:topic].present?
    items = items.joins(:languages).where(languages: { id: params[:language].to_i }) if params[:language].present?
    items = items.where("censorship_status = ?", params[:censorship_status]) if params[:censorship_status].present?

    items.map do |item|
      locations = item.geos.pluck(:id)
      if item.respond_to?(:place_of_origin_id)
        locations << item.place_of_origin_id
      end
      {
        title: item.title,
        type: item.class.name.downcase,
        place_of_origin: (item.respond_to?(:place_of_origin_id) and item.place_of_origin_id == location.id),
        location_ids: locations,
        slug: item.slug,
        authors: item.try(:authors)&.map(&:full_name)&.join(", "),
      }.compact
    end
  end

  def build_place(location, items)
    return nil unless location.mappable?
    {
      lat: location.latitude,
      lng: location.longitude,
      location_name: location.title,
      items: items.uniq,
    }
  end





  def fetch_related_novels(novel)
    # Track which criteria returned results
    matching_criteria = {}
    
    geo_novels = if novel.geos.any?
      results = Novel.joins(:geos)
           .where(geos: { id: novel.geos.pluck(:id) })
           .where.not(id: novel.id)
           .distinct
      matching_criteria[:locations] = novel.geos.map(&:title) if results.any?
      results
    else
      Novel.none
    end
    
    author_novels = if novel.authors.any?
      results = Novel.joins(:authors)
           .where(authors: { id: novel.authors.pluck(:id) })
           .where.not(id: novel.id)
           .distinct
      matching_criteria[:authors] = novel.authors.map(&:full_name) if results.any?
      results
    else
      Novel.none
    end

    keyword_novels = if novel.keywords.any?
      results = Novel.joins(:keywords)
           .where(keywords: { id: novel.keywords.pluck(:id) })
           .where.not(id: novel.id)
           .distinct
      matching_criteria[:keywords] = novel.keywords.map(&:label) if results.any?
      results
    else
      Novel.none
    end

    organization_novels = if novel.organizations.any?
      results = Novel.joins(:organizations)
           .where(organizations: { id: novel.organizations.pluck(:id) })
           .where.not(id: novel.id)
           .distinct
      matching_criteria[:organizations] = novel.organizations.map(&:title) if results.any?
      results
    else
      Novel.none
    end

    event_novels = if novel.events.any?
      results = Novel.joins(:events)
           .where(events: { id: novel.events.show_in_directory.pluck(:id) })
           .where.not(id: novel.id)
           .distinct
      matching_criteria[:events] = novel.events.show_in_directory.map(&:title) if results.any?
      results
    else
      Novel.none
    end

    people_novels = if novel.people.any?
      results = Novel.joins(:people)
           .where(people: { id: novel.people.show_in_directory.pluck(:id) })
           .where.not(id: novel.id)
           .distinct
      matching_criteria[:people] = novel.people.show_in_directory.map(&:full_name) if results.any?
      results
    else
      Novel.none
    end
    
    # Combine all queries using UNION in SQL
    related_novels = Novel.from(
      "(#{[
        geo_novels.to_sql,
        author_novels.to_sql,
        keyword_novels.to_sql,
        organization_novels.to_sql,
        event_novels.to_sql,
        people_novels.to_sql
      ].reject(&:blank?).join(' UNION ')}) AS novels"
    )
    
    # Group locations and their associated novels
    locations = {}
    
    # Add the novel's own locations first
    if novel.place_of_origin&.mappable?
        locations[novel.place_of_origin.id] ||= {
          lat: novel.place_of_origin.latitude,
          lng: novel.place_of_origin.longitude,
          location_name: novel.place_of_origin.title,
          items: []
      }
      locations[novel.place_of_origin.id][:items] << format_novel_for_location(novel, novel.place_of_origin.id, true)
    end
    
    # Add related novels at their place_of_origin
    related_novels.includes(:place_of_origin, :authors).each do |related_novel|
      next unless related_novel.place_of_origin&.mappable?
      
      origin = related_novel.place_of_origin
      locations[origin.id] ||= {
        lat: origin.latitude,
        lng: origin.longitude,
        location_name: origin.title,
        items: []
      }
      locations[origin.id][:items] << format_novel_for_location(related_novel, origin.id, false)
    end
    
    {
      locations: locations.values,
      matching_criteria: matching_criteria
    }
  end
  
  private
  
  def format_novel_for_location(novel, location_id, is_origin)
    {
      title: novel.title,
      type: 'novel',
      place_of_origin: is_origin,
      location_ids: [location_id],
      slug: novel.slug,
      authors: novel.authors.map(&:full_name).join(', ')
    }
  end


end
