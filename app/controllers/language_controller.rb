class LanguageController < ApplicationController

  def index
    languages_all = Language.all

    @languages = Language.page(params[:page]).per(12)
  end

  def show
    @language = Language.friendly.find(params[:id])
    @novels = @language.novels
  end

end
