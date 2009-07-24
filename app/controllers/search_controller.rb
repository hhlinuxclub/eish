class SearchController < ApplicationController
  before_filter :search_enabled
  
  def index
    set_meta_tags :title => "Search",
                  :description => "Search the HHLinuxClub site",
                  :keywords => "search"
  end

  def results
    @query = params[:query]
    
    @articles = Article.search(@query, :per_page => 3)
    @news = News.search(@query, :per_page => 3)
    @events = Event.search(@query, :per_page => 3)
    @galleries = Gallery.search(@query, :per_page => 3)
    @columns = 4
    
    set_meta_tags :title => "Searched for '" + @query + "'",
                  :description => "Searched for '" + @query + "'",
                  :keywords => "articles, events, news, galleries, search, " + @query
  end

  def articles
    @query = params[:query]
    @articles = Article.search(@query, :per_page => 10, :page => params[:page])
    
    set_meta_tags :title => "Searched for '" + @query + "'",
                  :description => "Searched for '" + @query + "'",
                  :keywords => "articles, search, " + @query
  end
  
  def news
    @query = params[:query]
    @news = News.search(@query, :per_page => 10, :page => params[:page])
    
    set_meta_tags :title => "Searched for '" + @query + "'",
                  :description => "Searched for '" + @query + "'",
                  :keywords => "news, search, " + @query
  end
  
  def events
    @query = params[:query]
    @events = Event.search(@query, :per_page => 10, :page => params[:page])
    
    set_meta_tags :title => "Searched for '" + @query + "'",
                  :description => "Searched for '" + @query + "'",
                  :keywords => "events, search, " + @query
  end
  
  def galleries
    @query = params[:query]
    @galleries = Gallery.search(@query)
    @columns = 4
    
    set_meta_tags :title => "Searched for '" + @query + "'",
                  :description => "Searched for '" + @query + "'",
                  :keywords => "galleries, images, search, " + @query
  end

  def opensearch
    @host = self.request.host_with_port
    @protocol = self.request.protocol

    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
