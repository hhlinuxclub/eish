class HomeController < ApplicationController
  
  def index
    news = News.find_all_by_published(true, :limit => 4, :select => "id, title, published_at", :order => "published_at DESC")
    articles = Article.find_all_by_published(true, :limit => 4, :select => "id, title, published_at", :order => "published_at DESC")
    @events = Event.available(4)
    @user = current_user unless !logged_in?
    @welcome_message = Setting.option("welcome_message")
    @featured_article = Article.featured
    
    @articles_and_news = [news, articles].flatten.sort { |x,y| y.published_at <=> x.published_at }
    
    respond_to do |format|
      format.html
    end
  end
end
