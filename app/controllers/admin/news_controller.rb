class Admin::NewsController < ApplicationController
  layout "admin"
 
  def index
    user = User.find(session[:user_id], :include => :role)
    if user.role.can_update? || user.role.can_delete? || user.role.can_publish? || user.role.can_administer?
      @news = News.find(:all)
    else
      @news = News.find_all_by_user_id(user.id)
    end

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
  
  def toggle_publish
    news_article = News.find(params[:id])
    news_article.published = !news_article.published
    
    respond_to do |format|
      if news_article.save
        flash[:notice] = news_article.published ? "The news article is now published." : "The news article is now unpublished."
      else
        flash[:error] = "Some error occurred. Nothing was changed."
      end
      format.html { redirect_to(admin_news_url) }
    end
  end
end
