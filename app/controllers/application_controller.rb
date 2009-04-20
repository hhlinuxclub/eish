# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :authorize
  before_filter :login_from_cookie
  before_filter :meta_defaults
  
  helper :all # include all helpers, all the time
  
  include ReCaptcha::AppHelper

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8573d4179016a43b27870a1f91bd5aae'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :current_password, :password_confirmation
  
  protected
  
    def authorize
      if session[:user_id].nil? || (!session[:user_id].nil? && User.find(session[:user_id]).normal_user?)
        session[:original_uri] = request.request_uri
        flash[:error] = "Please log in with enough privileges."
        redirect_to :login
      end
    end
    
    def login_from_cookie
      return unless cookies[:auth_token] && session[:user_id].nil?
      user = User.find_by_remember_token(cookies[:auth_token])
      if user && !user.remember_token_expires.nil? && Time.now < user.remember_token_expires
        session[:user_id] = user.id
      end
    end
    
    def check_for_admin
      unless User.find(session[:user_id]).role.can_administer?
        flash[:error] = "You do not have enough privileges."
        redirect_to :admin
      end
    end
  
    def meta_defaults
      @meta_title = ""
      @meta_keywords = "linux, club, haaga-helia, university"
      @meta_description = "HAAGA-HELIA Linux Club"
    end
end
