class Admin::HomeController < ApplicationController
  skip_after_filter :add_google_analytics_code
  layout "admin"
  
  def index
    @role = User.find(session[:user_id]).role
  end
end
