class TopicController < ApplicationController
  def index
    @pagination_params = {}

    keywords = Keyword.all

    if params[:order] == "name_asc"
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      keywords = keywords.order("LOWER(label) ASC")
    elsif params[:order] == "name_desc"
      @pagination_params[:order] = "name_desc"
      @filter_title = "Name (Descending)"
      keywords = keywords.order("LOWER(label) DESC")
    elsif params[:order] == "number_of_novels"
      @filter_title = "Number of novels"
      @pagination_params[:order] = "number_of_novels"
      keywords = keywords.all.sort_by { |t| t.novels.length }.reverse
    else
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      keywords = keywords.order("LOWER(label) ASC")
    end

    keywords = keywords.where("label ILIKE ?", "%" + params[:title] + "%") if params[:title].present?

    keywords = keywords.reject { |item| item.novels.length == 0 }.then { |a| Kaminari.paginate_array(a) }
    @keywords = keywords.page(params[:page]).per(params[:all] ? 999999 : 24)
    @site_title = "Topics"
  end

  def show
    @keyword = Keyword.friendly.find(params[:id])
    @site_title = @keyword.label
  end
end
