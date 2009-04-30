class SearchController < ApplicationController
  skip_before_filter :authorize
  # TODO: Stop search from functioning if it has been disabled in the settings
  
  def index
  end

  def results
    @query = params[:query]
    
    @articles = Article.search(@query, :per_page => 3)
    @news = News.search(@query, :per_page => 3)
    @events = Event.search(@query, :per_page => 3)
    
    respond_to do |format|
      format.html
    end
  end

  def articles
    @query = params[:query]
    @articles = Article.search(@query, :per_page => 10, :page => params[:page])
    
    respond_to do |format|
      format.html
    end
  end
  
  def news
    @query = params[:query]
    @news = News.search(@query, :per_page => 10, :page => params[:page])
    
    respond_to do |format|
      format.html
    end
  end
  
  def events
    @query = params[:query]
    @events = Event.search(@query, :per_page => 10, :page => params[:page])
    
    respond_to do |format|
      format.html
    end
  end 
end
