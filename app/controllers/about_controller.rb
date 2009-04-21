class AboutController < ApplicationController
  skip_before_filter :authorize
  
  def index
    @about = RedCloth.new(Setting.option("about")).to_html
    
    set_meta_tags :title => "About",
                  :description => "About page",
                  :keywords => "about, hhlinuxclub"
  end
end
