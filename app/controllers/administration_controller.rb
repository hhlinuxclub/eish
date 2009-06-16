class AdministrationController < ApplicationController
  before_filter :authorize
  layout "admin"
  
  protected
    
    def authorize
      if session[:user_id].nil? || (!session[:user_id].nil? && User.find(session[:user_id]).normal_user?)
        session[:original_uri] = request.request_uri
        flash[:error] = "Please log in with enough privileges."
        redirect_to :login
      end
    end
end
