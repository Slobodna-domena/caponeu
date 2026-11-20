class EventController < ApplicationController
  def index
    @types = EventType.where(hide_from_directory: [nil, false]).order(:label)
    events = Event.left_outer_joins(:event_types)
      .where("event_types.id IN (?) OR event_types.id IS NULL", @types.pluck(:id))
      .distinct

    if params[:order] == "name_asc"
      events = events.order("LOWER(title) ASC").page(params[:page]).per(24)
    elsif params[:order] == "name_desc"
      events = events.order("LOWER(title) DESC").page(params[:page]).per(24)
    else
      events = events.order(started: :desc).page(params[:page]).per(24)
    end

    events = events.where("events.title ILIKE ?", "%" + params[:title] + "%") if params[:title].present?
    events = events.joins(:event_types).where(event_types: { id: params[:type].to_i }) if params[:type].present?
    events = events.where("events.started >= '#{params[:from_date]}'") if params[:from_date].present?
    events = events.where("events.started <= '#{params[:to_date]}'") if params[:to_date].present?

    @events = events.page(params[:page]).per(params[:all] ? 999999 : 24)
    @site_title = "Events"
  end

  def show
    @event = Event.friendly.find(params[:id])
    @child_events = Event.where(main_event_id: @event.id).order("started asc")
    @site_title = @event.title
  end
end
