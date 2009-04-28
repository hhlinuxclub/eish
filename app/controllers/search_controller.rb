class SearchController < ApplicationController
  skip_before_filter :authorize
  
  def index
  end

  def results
    @terms = params[:terms]
    
    @articles = Article.find_with_ferret(params[:terms], {:limit => 3})
    @news = News.find_with_ferret(params[:terms], {:limit => 3})
    @events = Event.find_with_ferret(params[:terms], {:limit => 3})
    
    respond_to do |format|
      format.html
    end
  end

  def articles
    @articles = Article.find_with_ferret(params[:terms], :page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @articles }
    end
  end
  
  def news
    @news = Article.find_with_ferret(params[:terms], :page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @news }
    end
  end
  
  def events
    @events = Event.find_with_ferret(params[:terms], :page => params[:page], :per_page => 10)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @Events }
    end
  end
end
