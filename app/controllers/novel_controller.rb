class NovelController < ApplicationController
  def index
    @languages = Language.order(:label)
    @categories = Category.order(:label)
    @keywords = Keyword.order(:label)
    @pagination_params = {}

    novels = Novel.all

    if params[:order] == "name_asc"
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      novels = novels.order("LOWER(title) ASC")
    elsif params[:order] == "name_desc"
      @pagination_params[:order] = "name_desc"
      @filter_title = "Name (Descending)"
      novels = novels.order("LOWER(title) DESC")
    elsif params[:order] == "year"
      @pagination_params[:order] = "year"
      @filter_title = "Year"
      novels = novels.order(:from_year)
    else
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      novels = novels.order("LOWER(title) ASC")
    end

    novels = novels.where("novels.title ILIKE ? or novels.english_title ILIKE ? or novels.slug ILIKE ?", "%#{params[:title]}%", "%#{params[:title]}%", "%#{params[:title]}%") if params[:title].present?
    novels = novels.joins(:authors).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:author], params[:author], params[:author]) if params[:author].present?
    novels = novels.joins(:portrait_authors).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:portrait_author], params[:portrait_author], params[:portrait_author]) if params[:portrait_author].present?
    novels = novels.where("novels.from_year >= #{params[:from_year].to_i}") if params[:from_year].present?
    novels = novels.where("novels.from_year <= #{params[:to_year].to_i}") if params[:to_year].present?
    novels = novels.joins(:people).where("unaccent(people.first_name) ILIKE unaccent(?) OR unaccent(people.last_name) ILIKE unaccent(?) OR unaccent(CONCAT(first_name, ' ', last_name)) ILIKE unaccent(?)", params[:name], params[:name], params[:name]) if params[:name].present?
    novels = novels.joins(:organizations).where("organizations.label ILIKE '%" + params[:organization] + "%'") if params[:organization].present?
    novels = novels.joins(:categories).where(categories: { id: params[:category].to_i }) if params[:category].present?
    novels = novels.joins(:keywords).where(keywords: { id: params[:topic].to_i }) if params[:topic].present?
    novels = novels.joins(:languages).where(languages: { id: params[:language].to_i }) if params[:language].present?
    novels = novels.where("censorship_status = ?", params[:censorship_status]) if params[:censorship_status].present?

    @novels = novels.page(params[:page]).per(params[:all] ? 999999 : 12)
    @site_title = "Political novels"
  end

  def show
    @novel = Novel.find_by_slug(params[:id])
    @site_title = @novel.title if @novel
    @fb_image = @novel.cover.url if @novel && @novel.cover.url
    if params[:f] == "pdf"
      render pdf: "CAPONEU-#{@novel.slug}",
             template: "novel/show",
             layout: "pdf",
             disposition: "attachment",
             #show_as_html: true,
             formats: [:html]
    end
    check_redirect unless @novel
  end

  def authors_index
    redirect_to cdp_novels_authors_index_letter_path("A")
  end

  def authors_index_letter
    @site_title = "Authors index - #{params[:id]}"
    @letters = Novel.joins(:authors)
                   .where('people.last_name IS NOT NULL AND people.last_name != ?', '')
                   .pluck(Arel.sql('DISTINCT UPPER(LEFT(people.last_name, 1))'))
                   .sort
                   .map(&:upcase)
    query = Person.joins(:novel_authors)
                 .where('UPPER(LEFT(people.last_name, 1)) = ?', params[:id].to_s.upcase)
                 .order('people.last_name, people.first_name')
                 .distinct
                 .includes(:novel_authors)  # Preload the novels through the correct association
    @authors = query.to_a
  end



  # def search
  #   @languages = [["Any", ""]] + Language.all.map { |lang| [lang.label, lang.id] }
  #   @categories = [["Any", ""]] + Category.all.map { |cat| [cat.label, cat.id] }
  #   @keywords = [["Any", ""]] + Keyword.all.map { |cat| [cat.label, cat.id] }

  #   if params[:commit]
  #     @hide_search = true
  #     session[:params] = params
  #     s_title = "%" + Novel.sanitize_sql_like(params[:title]) + "%"
  #     @search = Novel
  #       .where("novels.title ILIKE ? or english_title ILIKE ? or slug ILIKE ?", s_title, s_title, s_title)
  #     @search = @search.joins(:geos).where("geos.title ILIKE '%" + params[:city] + "%'") if params[:city] != ""
  #     @search = @search.where("novels.language_id = ?", params[:language].to_i) if params[:language] != ""
  #     @search = @search.where("novels.from_year = ?", params[:year].to_i) if params[:year] != ""
  #     @search = @search.joins(:categories).where(categories: { id: params[:category].to_i }) if params[:category] != ""
  #     @search = @search.joins(:keywords).where(keywords: { id: params[:topic].to_i }) if params[:topic] != ""
  #     @search = @search.joins(:authors).where("people.first_name ILIKE '%" + Novel.sanitize_sql_like(params[:author]) + "%'").or(@search.joins(:authors).where("people.last_name ILIKE '%" + Novel.sanitize_sql_like(params[:author]) + "%'")).distinct if params[:author] != ""
  #   else
  #     @search = Array.new
  #   end
  # end
end
