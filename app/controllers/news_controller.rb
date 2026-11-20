class NewsController < ApplicationController
  def index
    reset_search_session
    @news = News.ordered_for_news_page.page(params[:page]).per(6)
  end

  def show
    @news = News.find(params[:id])
    @galleries_count = @news.galleries.not_empty.count
    @site_title = @news.title
  end
end
