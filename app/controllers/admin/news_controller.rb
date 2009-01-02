class Admin::NewsController < ApplicationController
  def index
    @news = News.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def show
    @news_article = News.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news_article }
    end
  end

  def new
    @news_article = News.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @news_article = News.find(params[:id])
  end

  def create
    @news_article = News.new(params[:news])
    @news_article.user_id = session[:user_id]

    respond_to do |format|
      if @news_article.save
        flash[:notice] = 'News was successfully created.'
        format.html { redirect_to(admin_news_article_path(@news_article)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @news_article = News.find(params[:id])

    respond_to do |format|
      if @news_article.update_attributes(params[:news_article])
        flash[:notice] = 'News was successfully updated.'
        format.html { redirect_to(admin_news_article_path(@news_article)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @news_article = News.find(params[:id])
    @news_article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_news_url) }
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
