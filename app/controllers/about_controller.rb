class AboutController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @about = RedCloth.new(Setting.option("about")).to_html
    
    @meta_title = "About"
    @meta_description = "About us"
  end
end
