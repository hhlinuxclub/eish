class AboutController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @about = RedCloth.new(Setting.option("about")).to_html
  end
end
