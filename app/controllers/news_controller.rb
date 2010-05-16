class NewsController < ApplicationController
  def index
    @news = News.published.paginate(:page => params[:page], :per_page => 5, :order => "published_at DESC", :include => :user)    
    
    set_meta_tags :title => "News",
                  :description => "Club news",
                  :keywords => "news"

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @news_article = News.published.find(params[:id].to_i)
    
    set_meta_tags :title => @news_article.title,
                  :description => "Club news",
                  :keywords => "news"

    respond_to do |format|
      format.html
    end
  end
end
