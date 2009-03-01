class Admin::ArticlesController < ApplicationController
  def index
    @articles = Article.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @articles }
    end
  end

  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @article }
    end
  end

  def new
    @article = Article.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])
    @article.user_id = session[:user_id]

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(admin_article_path(@article)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(admin_article_path(@article)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(admin_articles_url) }
    end
  end
  
  def publish
    article = Article.find(params[:id])
    article.published = true
    
    respond_to do |format|
      if article.save
        flash[:notice] = "The article is now published."
        format.html { redirect_to(admin_article_path(article)) }
      else
        flash[:error] = "Some error occurred. Nothing was changed."
        format.html { render :action => "show", :id => article.id }
      end
    end
  end
  
  def unpublish
    article = Article.find(params[:id])
    article.published = false
    
    respond_to do |format|
      if article.save
        flash[:notice] = "The article is now unpublished."
        format.html { redirect_to(admin_article_path(article)) }
      else
        flash[:error] = "Some error occurred. Nothing was changed."
        format.html { render :action => "show", :id => article.id }
      end
    end
  end
end
