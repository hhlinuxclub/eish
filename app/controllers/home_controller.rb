class HomeController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @news = News.find_all_by_published(true, :limit => 4, :order => "created_at DESC")
    @events = Event.upcoming(4)
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    @welcome_message = Setting.option("welcome_message")
    featured_article_id = Setting.option("featured_article").to_i
    @featured_article = Article.find(featured_article_id) unless featured_article_id == 0
  end
  
  def login
    login_with_credentials(params[:username], params[:password], params[:remember_me])
        
    respond_to do |format|
      format.html { redirect_to(:root) }
      format.js
    end
  end
end
