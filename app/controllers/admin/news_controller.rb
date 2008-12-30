class Admin::NewsController < ApplicationController
  # GET /news
  # GET /news.xml
  def index
    @news = News.find(:all)

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
      format.xml  { render :xml => @news_article }
    end
  end

  # GET /news/new
  # GET /news/new.xml
  def new
    @news_article = News.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news_article }
    end
  end

  # GET /news/1/edit
  def edit
    @news_article = News.find(params[:id])
  end

  # POST /news
  # POST /news.xml
  def create
    @news_article = News.new(params[:news])

    respond_to do |format|
      if @news_article.save
        flash[:notice] = 'News was successfully created.'
        format.html { redirect_to(admin_news_article_path(@news_article)) }
        format.xml  { render :xml => @news_article, :status => :created, :location => @news }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news_article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.xml
  def update
    @news_article = News.find(params[:id])

    respond_to do |format|
      if @news_article.update_attributes(params[:news_article])
        flash[:notice] = 'News was successfully updated.'
        format.html { redirect_to(admin_news_article_path(@news_article)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.xml
  def destroy
    @news_article = News.find(params[:id])
    @news_article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_news_url) }
      format.xml  { head :ok }
    end
  end
  
  def publish
    news_article = News.find(params[:id])
    news_article.published = true
    
    respond_to do |format|
      if news_article.save
        flash[:notice] = "The news article is now published."
        format.html { redirect_to (admin_news_article_path(news_article)) }
      else
        flash[:notice] = "Some error occurred. Nothing was changed."
        format.html { render :action => "show", :id => news_article.id }
      end
    end
  end
  
  def unpublish
    news_article = News.find(params[:id])
    news_article.published = false
    
    respond_to do |format|
      if news_article.save
        flash[:notice] = "The news article is now unpublished."
        format.html { redirect_to (admin_news_article_path(news_article)) }
      else
        flash[:notice] = "Some error occurred. Nothing was changed."
        format.html { render :action => "show", :id => news_article.id }
      end
    end
  end
end
