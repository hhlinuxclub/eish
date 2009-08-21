class NewsController < ApplicationController
  def index
    @news = News.paginate_all_by_published(true, :include => :user, :page => params[:page], :per_page => 5, :order => "published_at DESC")
    
    set_meta_tags :title => "News",
                  :description => "Club news",
                  :keywords => "news"

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @news_article = News.find_by_id_and_published(params[:id].to_i, true)
    
    set_meta_tags :title => @news_article.title,
                  :description => "Club news",
                  :keywords => "news"

    respond_to do |format|
      format.html
    end
  end
end
