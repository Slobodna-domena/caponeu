class CollectionsController < ApplicationController
  def index
    @pagination_params = {}

    if params[:order] == "name_asc"
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      collections = ThematicCollection.order("LOWER(title) ASC")
    elsif params[:order] == "name_desc"
      @pagination_params[:order] = "name_desc"
      @filter_title = "Name (Descending)"
      collections = ThematicCollection.order("LOWER(title) DESC")
    elsif params[:order] == "number_of_novels"
      @filter_title = "Number of novels"
      @pagination_params[:order] = "number_of_novels"
      collections = ThematicCollection.all.sort_by { |t| t.novels.length }.then { |a| Kaminari.paginate_array(a) }
    else
      @pagination_params[:order] = "name_asc"
      @filter_title = "Name (Ascending)"
      collections = ThematicCollection.active.order("LOWER(title) ASC")
      #collections = ThematicCollection.all
    end

    @collections = collections.page(params[:page]).per(24)
    @site_title = "Collections"
  end

  def show
    @collection = ThematicCollection.friendly.find(params[:id])
    @places = []
    @collection.thematic_sections.each do |section|
      if section.related_model == "Novels"
        section.novels.each do |novel|
          @places << build_place_for_items(novel.geos.first, [novel]) if novel.geos.any?
        end
      end
      if section.related_model == "Events"
        section.events.each do |event|
          @places << build_place_for_items(event.geos.first, [event]) if event.geos.any?
        end
      end
    end
    @site_title = @collection.title if @collection
    if params[:f] == "pdf"
      render pdf: "CAPONEU-#{@collection.slug}",
             template: "collections/show",
             layout: "pdf",
             disposition: "attachment",
             #  show_as_html: true,
             formats: [:html]
    end
  end
end
