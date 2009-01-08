class ArticlesController < ApplicationController
  skip_before_filter :authorize
  
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.find_all_by_published(true).reverse

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find_by_id_and_published(params[:id], true)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @articles }
    end
  end
end
