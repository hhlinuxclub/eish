class Admin::HomeController < ApplicationController
  layout "admin"
  
  def index
    @role = User.find(session[:user_id]).role
  end
end
