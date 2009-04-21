class HomeController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @news = News.find_all_by_published(true, :limit => 4, :order => "created_at DESC")
    @events = Event.upcoming(4)
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    @welcome_message = Setting.option("welcome_message")
    @featured_article = Article.featured
  end
end
