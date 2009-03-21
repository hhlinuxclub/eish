class Admin::ArticlesController < ApplicationController
  layout "admin"
 
  def index
    user = User.find(session[:user_id], :include => :role)
    if user.role.can_update? || user.role.can_delete? || user.role.can_publish? || user.role.can_administer?
      @articles = Article.find(:all, :order => "created_at DESC", :include => :article_revisions)
    else
      @articles = Article.find_all_by_user_id(user.id, :include => :article_revisions)
    end
    @featured_article = Setting.option("featured_article").to_i

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
  
  def toggle_publish
    article = Article.find(params[:id])
    article.published = !article.published
    
    respond_to do |format|
      if article.save
        flash[:notice] = article.published ? "The article is now published." : "The article is now unpublished."
      else
        flash[:error] = "Some error occurred. Nothing was changed."
      end
      format.html { redirect_to(admin_articles_url) }
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
    @title = params[:title]
    @description = params[:description]
    @body = RedCloth.new(params[:body]).to_html
    render :layout => false
  end
end
