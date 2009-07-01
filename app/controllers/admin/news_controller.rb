class Admin::NewsController < AdministrationController  
  def index
    set_meta_tags :title => "News"
    
    @news = News.find_all_for_user(current_user)
    
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
    set_meta_tags :title => "Create news article"

    @news_article = News.new
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @news_article = News.find(params[:id])
    
    set_meta_tags :title => "Editing '" + @news_article.title + "'"
    
    respond_to do |format|
      if @news_article.editable?(current_user)
        format.html
      else
        format.html { redirect_to admin_news_path }
      end
    end
  end

  def create
    @news_article = News.new(params[:news])
    @news_article.user_id = current_user_id

    respond_to do |format|
      if params[:preview]
        format.html { render :action => "new" }
      else
        if @news_article.save
          flash[:notice] = "News article successfully created."
          @news_article.assets.create(params[:asset].merge!(:user_id => current_user_id)) if params[:upload]
          format.html { redirect_to edit_admin_news_article_path @news_article }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end
  
  def update
    @news_article = News.find(params[:id])
    
    redirect_to admin_articles_path and return unless @news_article.editable?(current_user)
    
    if params[:upload]
      @news_article.assets.create(params[:asset].merge!(:user_id => current_user_id))
    elsif params[:destroy_asset]
      Asset.find(params[:destroy_asset]).destroy
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
    
    if current_user.role.can_delete?
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
  
  def bulk_action
    unless params[:news].nil?
      selected = []
      params[:news].each { |id, value| selected << id if value == "on" }
      news = News.find(selected)
    
      case params[:actions]
        when "delete"
          news.each { |n| n.destroy } if current_user.role.can_delete?
        when "publish"
          news.each { |n| n.publish } if current_user.role.can_publish?
        when "unpublish"
          news.each { |n| n.publish(false) } if current_user.role.can_publish?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_news_path }
    end
  end
end
