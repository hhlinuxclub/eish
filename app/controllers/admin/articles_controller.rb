class Admin::ArticlesController < AdministrationController  
  def index
    
    @articles = Article.find_all_for_user(current_user, :order => "id DESC")
    @featured_article = Setting.featured_article_id

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to :action => "edit" }
    end
  end

  def new
    
    @article = Article.new
    @category = Category.new
    @categories = Category.all

    respond_to do |format|
      format.html
    end
  end

  def edit
    @article = Article.find(params[:id], :include => :categories)
    @category = Category.new
    @categories = Category.all
    
    respond_to do |format|
      if @article.editable?(current_user)
        format.html
      else
        format.html { redirect_to admin_articles_path }
      end
    end
  end

  def create
    @article = Article.new(params[:article])
    @article.user_id = current_user_id
    @asset = @article.assets.build(params[:asset].merge!(:user_id => current_user_id)) if params[:upload]

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
    end
    @categories = Category.all

    respond_to do |format|
      if params[:create_category] || params[:destroy_category] || params[:preview]
        format.html { render :action => "new" }
      else
        if @article.save
          flash[:notice] = "Article successfully created."
          format.html { redirect_to edit_admin_article_path @article }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end
  
  def update
    @article = Article.find(params[:id])

    redirect_to admin_articles_path and return unless @article.editable?(current_user)
    
    if params[:upload]
      @asset = @article.assets.create(params[:asset].merge!(:user_id => current_user_id))
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
    end
    
    @article.attributes = params[:article]
    @categories = Category.all

    respond_to do |format|
      if params[:upload] || params[:create_category] || params[:destroy_asset] || params[:destroy_category] || params[:preview]
        format.html { render :action => "edit" }
      elsif params[:diff]
        format.html { redirect_to diff_path }
      else
        @article.updated_by_user_id = current_user_id
        if params[:image] == "nil"
          @article.image = nil
        else
          @article.image_id = params[:image]
        end
        if @article.save
          flash[:notice] = "Article was successfully updated."
          format.html { redirect_to admin_article_path(@article) }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    
    if current_user.role.can_delete?
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
  
  def compare
    @rev_a = Revision.find_by_article_id_and_number(params[:id].to_i, params[:rev_a])
    @rev_b = Revision.find_by_article_id_and_number(params[:id].to_i, params[:rev_b])

    respond_to do |format|
      if !@rev_a.nil? && !@rev_b.nil?
        format.html { @diff = Diff.new(@rev_a.body, @rev_b.body) }
      else
        format.html { redirect_to edit_admin_article_path(:id => params[:id]) }
      end
    end
  end
  
  def change_revision
    article = Article.find(params[:id])
    
    article.change_to_revision(params[:revision]) if current_user.role.can_update? || current_user_id == article.user_id
    
    respond_to do |format|
      format.html { redirect_to edit_admin_article_path(params[:id]) }
    end
  end
  
  def bulk_action
    unless params[:articles].nil?
      selected = []
      params[:articles].each { |id, value| selected << id if value == "on" }
      articles = Article.find(selected)
      featured_article = Article.featured
    
      case params[:actions]
        when "delete"
          if articles.include? featured_article
            flash[:error] = "Cannot delete the featured article."
          else
            articles.each { |a| a.destroy } if current_user.role.can_delete?
          end
        when "publish"
          articles.each { |a| a.update_attribute(:published, true) } if current_user.role.can_publish?
        when "unpublish"
          if articles.include? featured_article
            flash[:error] = "Cannot unpublish the featured article."
          else
            articles.each { |a| a.update_attribute(:published, false) } if current_user.role.can_publish?
          end
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_articles_path }
    end
  end
  
  def unpublish
    article = Article.find(params[:id])
    
    if article == Article.featured
      flash[:error] = "Cannot unpublish the featured article."
    else
      article.update_attribute(:published, false) if current_user.role.can_publish?
      flash[:notice] = "The article was unpublished."
    end
    
    respond_to do |format|
      format.html { redirect_to admin_articles_path }
    end
  end
  
  def publish
    article = Article.find(params[:id])
    
    article.update_attribute(:published, true) if current_user.role.can_publish?
    
    respond_to do |format|
      flash[:notice] = "The article was published."
      format.html { redirect_to admin_articles_path }
    end
  end
end
