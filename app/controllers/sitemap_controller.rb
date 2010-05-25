class SitemapController < ApplicationController
  before_filter :require_http
  
  def index
    @articles = Article.published
    @news = News.published
    @upcoming_events = Event.upcoming
    @ongoing_events = Event.ongoing
    @past_events = Event.past
    @galleries = Gallery.published.not_null
    @categories = Category.all_alphabetically

    respond_to do |format|
      format.xml { render :layout => false }
      format.html
    end
  end
end
