class ArticlesController < ApplicationController
  skip_before_filter :authorize

  def index
    @articles = Article.paginate_all_by_published(true, :page => params[:page], :per_page => 10, :limit => 5, :order => "created_at DESC")
    @categories = Category.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @articles }
      format.atom { @articles = Article.find_all_by_published(true, :limit => 10, :order => "created_at DESC") } 
    end
  end

  def show
    @article = Article.find_by_id_and_published(params[:id], true)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @articles }
    end
  end
  
  def categories
    @category = Category.find(params[:id])
    @articles = Article.paginate_all_by_published true, :page => params[:page], :per_page => 10, :joins => "INNER JOIN categorizations ON categorizations.article_id = articles.id INNER JOIN categories ON categories.id = categorizations.category_id", :conditions => ["categories.id = ?", params[:id]], :order => "articles.created_at DESC"
    @categories = Category.all
  end
end
