class EditionController < ApplicationController
  def show
    @edition = Edition.find(params[:id])
    @site_title = @edition.title
  end
end
