class Admin::NewsController < ApplicationController
  layout "admin"
 
  def index
    user = User.find(session[:user_id])
    if user.role.can_update? || user.role.can_delete? || user.role.can_publish? || user.role.can_administer?
      @news = News.find(:all, :order => "created_at DESC")
    else
      @news = News.find_all_by_user_id(user.id, :order => "created_at DESC")
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @news }
    end
  end

  def show
    redirect_to :action => "edit"
  end

  def new
    @news_article = News.new
    user = User.find(session[:user_id])

    respond_to do |format|
      if user.role.can_create?
        format.html
      else
        format.html { redirect_to admin_news_path }
      end
    end
  end

  def edit
    @news_article = News.find(params[:id])
    user = User.find(session[:user_id])
    
    respond_to do |format|
      if user.role.can_update? || user.id == @news_article.user_id
        format.html
      else
        format.html { redirect_to admin_news_path }
      end
    end
  end

  def create
    @news_article = News.new(params[:news])
    @news_article.user_id = session[:user_id]
    user = User.find(session[:user_id])

    respond_to do |format|
      if user.role.can_create?
        if @news_article.save
          flash[:notice] = "News was successfully created."
          format.html { redirect_to admin_news_article_path(@news_article) }
        else
          format.html { render :action => "new" }
        end
      else
        format.html { redirect_to admin_news_path }
      end
    end
  end

  def update
    @news_article = News.find(params[:id])
    user = User.find(session[:user_id])

    respond_to do |format|
      if user.role.can_update? || user.id == @news_article.user_id
        if @news_article.update_attributes(params[:news_article])
          flash[:notice] = "News was successfully updated."
          format.html { redirect_to admin_news_article_path(@news_article) }
        else
          format.html { render :action => "edit" }
        end
      else
        format.html { redirect_to admin_news_path }
      end
    end
  end

  def destroy
    @news_article = News.find(params[:id])
    user = User.find(session[:user_id])
    
    if user.role.can_delete?
      if @news_article.destroy
        flash[:notice] = "News article was successfully deleted."
      else
        flash[:error] = "Some error happened. The news article was not deleted."
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_news_path }
    end
  end
  
  def preview
    render :layout => false
  end
  
  def bulk_action
    unless params[:news].nil?
      selected = []
      params[:news].each { |id, value| selected << id if value == "on" }
      news = News.find(selected)
      user = User.find(session[:user_id])
    
      case params[:actions]
        when "delete"
          news.each { |n| n.destroy } if user.role.can_delete?
        when "publish"
          news.each { |n| n.publish } if user.role.can_publish?
        when "unpublish"
          news.each { |n| n.publish(false) } if user.role.can_publish?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_news_path }
    end
  end
end
