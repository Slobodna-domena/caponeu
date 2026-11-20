class HomepageController < ApplicationController
  BASE_URL = "https://openlibrary.org"

  def index
    reset_search_session
    @news = News.where("priority < ?", 4).order(:priority, :created_at).limit(3)
  end

  def about
    @places = []
    @members = OrganizationType.find_by_label("Caponeu Consortium Member").organizations.order(:sort)
    @third_party = OrganizationType.find_by_label("Third party members with payment").organizations.order(:sort)
    @members.each do |org|
      @places << build_place_for_items(org.geos.first, [org]) if org.geos.any?
    end
    @site_title = "About CAPONEU"
  end

  def events
    @events = []
    Event.not_hidden.joins(:event_types).where("event_types.label = 'Caponeu event'").uniq.each do |event|
      @events << build_place_for_items(event.geos.first, [event]) if event.geos.any?
    end
    
    @events_for_map = @events.group_by { |e| e[:location_name] }.map do |location_name, location_events|
      first = location_events.first
      {
        lat: first[:lat],
        lng: first[:lng],
        location_name: location_name,
        items: location_events.flat_map { |loc| loc[:items] }
      }
    end

    @site_title = "Events"
  end

  def team
    @places = []
    @members = OrganizationType.find_by_label("Caponeu Consortium Member").organizations.order(:sort)
    @third_party = OrganizationType.find_by_label("Third party members with payment").organizations.order(:sort)
    @externals = PersonType.find_by_label("External Contributor").people
    @members.each do |org|
      @places << build_place_for_items(org.geos.first, [org]) if org.geos.any?
    end
    @site_title = "CAPONEU Team"
  end

  def openlibrary
    fetch_work_id(params[:q])
    render json: @content
  end

  def error
    status = params[:code] || 500
    @site_title = status
    render status, status: status
  end

  private

  def fetch_editions(work_id)
    endpoint = "/works/#{work_id}/editions.json"
    url = URI("#{BASE_URL}#{endpoint}")

    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    if data["entries"]
      data["entries"].each_with_index do |edition, index|
        display_edition_info(edition)
      end
    end
  end

  def fetch_work_id(book_title)
    endpoint = "/search.json"
    url = URI("#{BASE_URL}#{endpoint}?title=#{URI.encode_www_form_component(book_title)}")

    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    exact_matches = data["docs"].select { |book| book["title"].casecmp?(book_title) }
    @content = []
    exact_matches.each_with_index do |doc, index|
      fetch_editions(doc["key"].gsub("/works/", "")) if doc["key"]
    end
  end

  def display_edition_info(edition)
    @content << {
      title: edition.fetch("title", ""),
      year: edition.fetch("year", ""),
      isbn: edition.fetch("isbn_10", [""]).join(", "),
      publisher: get_publisher_id(edition.fetch("publisher", [""]).join(", ")),
    }
  end

  def get_publisher_id(publisher_name)
    return "" if publisher_name.blank?
    organization = Organization.find_or_create_by(label: publisher_name)
    if organization.organization_types.empty?
      organization.organization_types << OrganizationType.find_by_label("Publisher")
      organization.added_by = "Open Library API"
    end
    organization.save
    [organization.id, organization.label]
  end
end
