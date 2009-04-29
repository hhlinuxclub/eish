class SearchController < ApplicationController
  skip_before_filter :authorize
  
  def index
  end

  def results
    @query = params[:query]
    
    @articles = Article.find_with_ferret(params[:query], :limit => 3, :conditions => ['published = ?', true])
    @news = News.find_with_ferret(params[:query], :limit => 3, :conditions => ['published = ?', true])
    @events = Event.find_with_ferret(params[:query], :limit => 3, :conditions => ['published = ?', true])
    
    respond_to do |format|
      format.html
    end
  end

  def articles
    @query = params[:query]
    @articles = Article.find_with_ferret(params[:query], :page => params[:page], :per_page => 10, :conditions => ['published = ?', true])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @articles }
    end
  end
  
  def news
    @query = params[:query]
    @news = Article.find_with_ferret(params[:query], :page => params[:page], :per_page => 10, :conditions => ['published = ?', true])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @news }
    end
  end
  
  def events
    @query = params[:query]
    @events = Event.find_with_ferret(params[:query], :page => params[:page], :per_page => 10, :conditions => ['published = ?', true])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @Events }
    end
  end
end
