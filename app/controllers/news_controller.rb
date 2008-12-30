class NewsController < ApplicationController
  skip_before_filter :authorize
  
  # GET /news
  # GET /news.xml
  def index
    @news = News.find(:all).reverse

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  # GET /news/1
  # GET /news/1.xml
  def show
    @news_article = News.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news }
    end
  end
end
