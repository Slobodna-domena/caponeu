class TimelineController < ApplicationController
  def index
    novels = Novel.where.not(from_year: nil).order(:from_year)
    @keywords = Keyword.order(:label)

    novels = novels.joins(:authors).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:author], params[:author], params[:author]) if params[:author].present?
    novels = novels.joins(:keywords).where(keywords: { id: params[:topic].to_i }) if params[:topic].present?
    novels = novels.where("novels.from_year >= #{params[:from_year].to_i}") if params[:from_year].present?
    novels = novels.where("novels.from_year <= #{params[:to_year].to_i}") if params[:to_year].present?

    @novels = novels.group_by(&:from_year)
    @site_title = "Timeline"
  end
end
