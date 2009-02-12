class HomeController < ApplicationController
  def index
    @news = News.find_all_by_published(true, :limit => 4, :order => "created_at DESC")
  end
end
