class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
  before_action :set_paper_trail_request_info

  def user_for_paper_trail
    # Return the user or admin_user for tracking
    admin_user_signed_in? ? current_admin_user.id : nil
  end

  def info_for_paper_trail
    {
      metadata: {
        ip: request.remote_ip,
        user_agent: request.user_agent,
      }.to_json,
    }
  end

  def build_place_for_items(location, items)
    items = items.map do |item|
      {
        title: item.title,
        type: item.class.name.downcase,
        slug: item.slug,
        place_of_origin: item.respond_to?(:place_of_origin_id),
      }.compact
    end
    {
      lat: location.latitude,
      lng: location.longitude,
      location_name: location.title,
      items: items,
    }
  end

  private

  def dbg(message)
    puts Rainbow("---------------------------------").green
    puts Rainbow(message).lime
    puts Rainbow("=================================").green
  end

  def set_paper_trail_request_info
    PaperTrail.request.controller_info = info_for_paper_trail
  end

  def reset_search_session
    session[:params] = nil
  end

  def check_redirect
    redirect = Redirect.find_by_old_url(request.fullpath)
    if redirect
      redirect_to redirect.new_url, status: 301
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
