class Admin::AboutController < ApplicationController
  def index
    @about = Setting.option("about")
  end
  
  def update
    setting = Setting.find_by_option("about")
    
    respond_to do |format|
      if setting.update_attribute("value", params[:about])
        flash[:notice] = "About text successfully saved."
      else
        flash[:error] = "Something went wrong..."
      end
      format.html { redirect_to :controller => "about" }
    end
  end
end
