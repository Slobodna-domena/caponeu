class OrganizationController < ApplicationController
  def index
    @pagination_params = {}
    @types = OrganizationType.where(hide_from_directory: [nil, false]).order(:label)
    

    organizations = Organization.all

    if params[:order] == "name_asc"
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      organizations = organizations.order("LOWER(organizations.label) ASC")
    elsif params[:order] == "name_desc"
      @pagination_params[:order] = "name_desc"
      @filter_title = "Name (Descending)"
      organizations = organizations.order("LOWER(organizations.label) DESC")
    else
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      organizations = organizations.order("LOWER(organizations.label) ASC")
    end

    organizations = organizations.where("organizations.label ILIKE ?", "%" + params[:title] + "%") if params[:title].present?
    organizations = organizations.joins(:organization_types).where(organization_types: { id: params[:type].to_i }) if params[:type].present?

    @organizations = organizations.page(params[:page]).per(params[:all] ? 999999 : 24)
    @site_title = "Organizations"
  end

  def show
    @organization = Organization.friendly.find(params[:id])
    @site_title = @organization.label
  end
end
