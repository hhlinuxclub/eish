class ArticlesController < ApplicationController
  def index
    @articles = Article.published.paginate(:page => params[:page], :per_page => 10, :order => "published_at DESC", :include => :user)    
    @categories = Category.all_alphabetically
    
    set_meta_tags :title => "Articles",
                  :description => "Articles published by HHLinuxClub",
                  :keywords => "articles, tutorials, reviews"

    respond_to do |format|
      format.html
      format.atom { @articles = Article.published.find(:all, :limit => 10, :order => "published_at DESC") }
    end
  end

  def show
    @article = Article.published.find(params[:id].to_i)
    
    set_meta_tags :title => @article.title,
                  :description => @article.description,
                  :keywords => keywords_from_categories(@article.categories) unless @article.categories == nil
    
    respond_to do |format|
      format.html
    end
  end
  
  def categories
    @category = Category.find(params[:id])
    @articles = @category.articles.published.paginate(:page => params[:page], :per_page => 10, :order => "published_at DESC", :include => :user)    
    @categories = Category.all_alphabetically
    
    set_meta_tags :title => @category.name,
                  :description => "Articles published by HHLinuxClub",
                  :keywords => "articles, tutorials, reviews"
  end
  
protected
 
  def keywords_from_categories(categories)
    keywords = ""
    
    categories.each do |c|
      keywords << c.name + ", "
    end
    
    return keywords
  end
end
