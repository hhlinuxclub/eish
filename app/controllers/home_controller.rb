class HomeController < ApplicationController  
  def index
    @news = News.find_all_by_published(true, :limit => 4, :order => "created_at DESC")
    
    ongoing_events = Event.ongoing
    upcoming_events = Event.upcoming(4 - ongoing_events.count)
    @events = ongoing_events + upcoming_events
    
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    @welcome_message = Setting.option("welcome_message")
    @featured_article = Article.featured
  end
end
