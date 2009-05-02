class Admin::ArticlesController < ApplicationController
  skip_after_filter :add_google_analytics_code
  layout "admin"
   
  def index
    user = User.find(session[:user_id])
    
    set_meta_tags :title => "Articles"
    
    if user.role.can_update? || user.role.can_delete? || user.role.can_publish? || user.role.can_administer?
      @articles = Article.find(:all, :order => "created_at DESC", :include => :revisions)
    else
      @articles = Article.find_all_by_user_id(user.id, :order => "created_at DESC", :include => :revisions)
    end
    @featured_article = Setting.option("featured_article").to_i

    respond_to do |format|
      format.html
      format.xml  { render :xml => @articles }
    end
  end

  def show
    redirect_to :action => "edit"
  end

  def new
    @article = Article.new
    @category = Category.new
    @categories = Category.all
    user = User.find(session[:user_id])
    
    set_meta_tags :title => "Create new article"

    respond_to do |format|
      if user.role.can_create?
        format.html
      else
        format.html { redirect_to admin_articles_path }
      end
    end
  end

  def edit
    @article = Article.find(params[:id], :include => :categories)
    @category = Category.new
    @categories = Category.all
    user = User.find(session[:user_id])
    
    set_meta_tags :title => "Editing '" + @article.title + "'"
    
    respond_to do |format|
      if user.role.can_update? || user.id == @article.user_id
        format.html
      else
        format.html { redirect_to admin_articles_path }
      end
    end
  end

  def create
    user = User.find(session[:user_id])

    redirect_to admin_articles_path and return unless user.role.can_create?

    @article = Article.new(params[:article])
    @article.category_ids = params[:categories].keys.to_a unless params[:categories].nil?
    @article.user_id = session[:user_id]

    if params[:create_category]
      category = Category.create!(params[:category])
      @article.categories << category
    elsif params[:destroy_category]
      category = Category.find(params[:destroy_category])
      if category.articles.empty?
        category.destroy
      else
        flash.now[:error] = "The category " + category.name + " has articles associated with it."
      end
    elsif params[:preview]
      @preview = @article
    end
    @categories = Category.all

    respond_to do |format|
      if params[:create_category] || params[:destroy_category] || params[:preview]
        format.html { render :action => "new" }
      else
        if @article.save
          @article.assets.create(params[:asset].merge!(:user_id => user.id)) if params[:upload]
          format.html { redirect_to edit_admin_article_path @article }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end
  
  def update
    user = User.find(session[:user_id])
    @article = Article.find(params[:id])

    if !user.role.can_update? && @article.user_id != user.id
      redirect_to admin_articles_path and return
    end
    
    @article.category_ids = params[:categories].keys.to_a unless params[:categories].nil?

    if params[:upload]
      @article.assets.create(params[:asset].merge!(:user_id => user.id))
    elsif params[:create_category]
      category = Category.create!(params[:category])
      @article.categories << category
    elsif params[:destroy_asset]
      Asset.find(params[:destroy_asset]).destroy
    elsif params[:destroy_category]
      category = Category.find(params[:destroy_category])
      if category.articles.empty?
        flash.now[:notice] = "The category '" + category.name + "' has been removed."
        category.destroy
      else
        flash.now[:error] = "The category '" + category.name + "' has articles associated with it."
      end
    elsif params[:diff]
      diff_path = article_diff_path :id => params[:id], :rev_a => params[:rev_a], :rev_b => params[:rev_b]
    elsif params[:preview]
      @preview = @article
    end
    
    @article.attributes = params[:article]
    @categories = Category.all

    respond_to do |format|
      if params[:upload] || params[:create_category] || params[:destroy_asset] || params[:destroy_category] || params[:article]
        format.html { render :action => "edit" }
      elsif params[:diff]
        format.html { redirect_to diff_path }
      else
        @article.updated_by_user_id = session[:user_id]
        if params[:image] == "nil"
          @article.image = nil
        else
          @article.image_id = params[:image]
        end
        if @article.save
          flash[:notice] = "Article was successfully updated."
          format.html { redirect_to admin_article_path(@article) }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    user = User.find(session[:user_id])
    
    if user.role.can_delete?
      if @article.destroy
        flash[:notice] = "Article was successfully deleted."
      else
        flash[:error] = "Some error happened. The article was not deleted."
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_articles_path }
    end
  end
  
  def feature
    setting = Setting.find_by_option("featured_article")
    article_to_feature = params[:id]
    
    respond_to do |format|
      if Article.find(article_to_feature).published?
        if setting.update_attribute("value", article_to_feature)
          flash[:notice] = "Article is now featured."
        else
          flash[:error] = "Something went wrong..."
        end
      else
        flash[:error] = "Cannot feature an unpublished article."
      end
      format.html { redirect_to admin_articles_url }
    end
  end
  
  def preview
    render :layout => false
  end
  
  def compare
    @rev_a = Revision.find_by_article_id_and_number(params[:id].to_i, params[:rev_a])
    @rev_b = Revision.find_by_article_id_and_number(params[:id].to_i, params[:rev_b])
    
    set_meta_tags :title => "Compare Revisions"
    
    respond_to do |format|
      if !@rev_a.nil? && !@rev_b.nil?
        format.html { @diff = diff(@rev_a.body, @rev_b.body) }
      else
        format.html { redirect_to edit_admin_article_path(:id => params[:id]) }
      end
    end
  end
  
  def change_revision
    article = Article.find(params[:id])
    user = User.find(session[:user_id])
    
    article.change_to_revision(params[:revision]) if user.role.can_update? || user.id == article.user_id
    
    respond_to do |format|
      format.html { redirect_to edit_admin_article_path(params[:id]) }
    end
  end
  
  def bulk_action
    unless params[:articles].nil?
      selected = []
      params[:articles].each { |id, value| selected << id if value == "on" }
      articles = Article.find(selected)
      user = User.find(session[:user_id])
      featured_article = Article.featured
    
      case params[:actions]
        when "delete"
          if articles.include? featured_article
            flash[:error] = "Cannot delete the featured article."
          else
            articles.each { |a| a.destroy } if user.role.can_delete?
          end
        when "publish"
          articles.each { |a| a.publish } if user.role.can_publish?
        when "unpublish"
          if articles.include? featured_article
            flash[:error] = "Cannot unpublish the featured article."
          else
            articles.each { |a| a.publish(false) } if user.role.can_publish?
          end
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_articles_path }
    end
  end
end
