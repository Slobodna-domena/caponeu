class CategoryController < ApplicationController
  def index
    @categories = Category.all.page(params[:page]).per(12)
    @site_title = "Categories"
  end

  def show
    @category = Category.friendly.find(params[:id])
    @novels = Novel.joins(:categories).where("categories.id = ?", @category.id)
    @site_title = @category.label
    # @materials = Material.joins(:categories).where("categories.id = ?", params[:id])
  end
end
