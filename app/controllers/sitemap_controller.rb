class SitemapController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @articles = Article.paginate_all_by_published(true, :page => params[:page], :per_page => 10, :limit => 5, :order => "created_at DESC")
    @news = News.paginate_all_by_published(true, :include => :user, :page => params[:page], :per_page => 5, :order => "created_at DESC")
    @upcoming_events = Event.upcoming
    @ongoing_events = Event.ongoing
    @past_events = Event.past
    @categories = Category.all_alphabetically
    
    respond_to do |format|
      format.xml { render :layout => false }
      format.html
    end
  end
end
