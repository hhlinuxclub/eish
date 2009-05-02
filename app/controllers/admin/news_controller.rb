class Admin::NewsController < ApplicationController
  skip_after_filter :add_google_analytics_code
  layout "admin"
 
  def index
    user = User.find(session[:user_id])
    
    set_meta_tags :title => "News"
    
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
    
    set_meta_tags :title => "Create news article"

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
    
    set_meta_tags :title => "Editing '" + @news_article.title + "'"
    
    respond_to do |format|
      if user.role.can_update? || user.id == @news_article.user_id
        format.html
      else
        format.html { redirect_to admin_news_path }
      end
    end
  end

  def create
    user = User.find(session[:user_id])
    
    redirect_to admin_articles_path and return unless user.role.can_create?
    
    @news_article = News.new(params[:news])
    @news_article.user_id = session[:user_id]

    respond_to do |format|
      if params[:preview]
        @preview = @news_article
        format.html { render :action => "new" }
      else
        if @news_article.save
          flash[:notice] = "News article successfully created."
          @news_article.assets.create(params[:asset].merge!(:user_id => user.id)) if params[:upload]
          format.html { redirect_to edit_admin_news_article_path @news_article }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end
  
  def update
    @news_article = News.find(params[:id])
    user = User.find(session[:user_id])
    
    if !user.role.can_update? && @news_article.user_id != user.id
      redirect_to admin_articles_path and return
    end
    
    if params[:upload]
      @news_article.assets.create(params[:asset].merge!(:user_id => user.id))
    elsif params[:destroy_asset]
      Asset.find(params[:destroy_asset]).destroy
    elsif params[:preview]
      @preview = @news_article
    else
      if params[:image] == "nil"
        @news_article.image = nil
      else
        @news_article.image_id = params[:image]
      end
    end
    
    @news_article.attributes = params[:news_article]

    respond_to do |format|
      if params[:upload] || params[:destroy_asset] || params[:preview]
        format.html { render :action => "edit" }
      else
        if @news_article.save
          flash[:notice] = "News article was successfully updated."
          format.html { redirect_to admin_news_article_path @news_article }
        else
          format.html { render :action => "edit" }
        end
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
