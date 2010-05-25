class ArticlesController < ApplicationController
  def index
    @articles = Article.published.paginate(:page => params[:page], :per_page => 10, :order => "published_at DESC", :include => :user)    
    @categories = Category.all_alphabetically

    respond_to do |format|
      format.html
      format.atom { @articles = Article.published.find(:all, :limit => 10, :order => "published_at DESC") }
    end
  end

  def show
    @article = Article.published.find(params[:id].to_i)
    
    respond_to do |format|
      format.html
    end
  end
  
  def categories
    @category = Category.find(params[:id])
    @articles = @category.articles.published.paginate(:page => params[:page], :per_page => 10, :order => "published_at DESC", :include => :user)    
    @categories = Category.all_alphabetically
  end
end
