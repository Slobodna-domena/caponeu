class MaterialController < ApplicationController
  def index
    @keywords = Keyword.order(:label)
    @types = MaterialType.order(:label)
    @pagination_params = {}

    materials = Material.where("published_until >= ? or published_until is null", Date.today)

    if params[:order] == "name_asc"
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      materials = materials.order("LOWER(title) ASC")
    elsif params[:order] == "name_desc"
      @pagination_params[:order] = "name_desc"
      @filter_title = "Name (Descending)"
      materials = materials.order("LOWER(title) DESC")
    elsif params[:order] == "date"
      @pagination_params[:order] = "date"
      @filter_title = "Date"
      materials = materials.order(:created_at)
    else
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      materials = materials.order("LOWER(title) ASC")
    end

    materials = materials.where("unaccent(materials.title) ILIKE ?", "%" + params[:title] + "%") if params[:title].present?
    materials = materials.joins(:authors).where("unaccent(people.first_name) ILIKE '%" + params[:author] + "%'").or(materials.joins(:authors).where("unaccent(people.last_name) ILIKE '%" + params[:author] + "%'")) if params[:author].present?
    materials = materials.joins(:keywords).where(keywords: { id: params[:topic].to_i }) if params[:topic].present?
    materials = materials.joins(:material_types).where(material_types: { id: params[:type].to_i }) if params[:type].present?
    materials = materials.where(produced_by_caponeu: true) if params[:produced_by_caponeu].present?

    @materials = materials.page(params[:page]).per(params[:all] ? 999999 : 24)
    @site_title = "Materials"
  end

  # def search
  #   @keywords = [["Any", ""]] + Keyword.all.map { |cat| [cat.label, cat.id] }
  #   @types = [["Any", ""]] + MaterialType.all.map { |cat| [cat.label, cat.id] }

  #   if params[:commit]
  #     @hide_search = true
  #     session[:material_params] = params
  #     @search = Material.where("materials.title ILIKE ?", "%" + Novel.sanitize_sql_like(params[:title]) + "%")
  #     @search = @search.joins(:keywords).where(keywords: { id: params[:topic].to_i }) if params[:topic] != ""
  #     @search = @search.joins(:material_types).where(material_types: { id: params[:type].to_i }) if params[:type] != ""

  #     @page = params[:index].to_i

  #     @materials = @search.page(@page).per(12)
  #   end
  # end

  def show
    begin
      @material = Material.where("published_until >= ? or published_until is null", Date.today).friendly.find(params[:id])
      @events = @material.events
      @site_title = @material.title
    rescue ActiveRecord::RecordNotFound
      redirect_to cdp_materials_path
    end
  end
end
