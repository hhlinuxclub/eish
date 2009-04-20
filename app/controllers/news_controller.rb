class NewsController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @news = News.paginate_all_by_published(true, :include => :user, :page => params[:page], :per_page => 5, :order => "created_at DESC")
    
    @meta_title = "News"
    @meta_description = "HHLinuxClub news"
    @meta_keywords = @meta_keywords + ", news"

    respond_to do |format|
      format.html
      format.xml  { render :xml => @news }
      format.atom
    end
  end

  def show
    @news_article = News.find_by_id_and_published(params[:id].to_i, true)
    
    @meta_title = @news_article.title
    @meta_description = "HHLinuxClub news"

    respond_to do |format|
      format.html
      format.xml  { render :xml => @news_article }
      format.json { render :json => @news_article }
    end
  end
end
