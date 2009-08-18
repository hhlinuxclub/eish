class HomeController < ApplicationController
  before_filter :require_http
  
  def index
    @news = News.find_all_by_published(true, :limit => 4, :order => "created_at DESC")
    @events = Event.available(4)
    @user = current_user unless !logged_in?
    @welcome_message = Setting.option("welcome_message")
    @featured_article = Article.featured
    
    respond_to do |format|
      format.html
    end
  end
end
