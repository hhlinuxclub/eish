class Admin::SettingsController < ApplicationController
  skip_after_filter :add_google_analytics_code
  layout "admin"
  
  def index
    @welcome_message = Setting.option("welcome_message")
  end
  
  def update
    setting = Setting.find_by_option("welcome_message")
    
    respond_to do |format|
      if setting.update_attribute("value", params[:welcome_message])
        flash[:notice] = "Welcome message successfully saved."
      else
        flash[:error] = "Something went wrong..."
      end
      format.html { redirect_to :controller => "settings" }
    end
  end
end
