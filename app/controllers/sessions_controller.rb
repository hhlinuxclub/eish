class SessionsController < ApplicationController
  before_filter :require_https, :only => [:new, :create] if HTTPS_ENABLED
  before_filter :not_logged_in, :only => [:new, :create]
  
  def new
    set_meta_tags :title => 'Login',
                  :description => 'Login page',
                  :keywords => 'Site, Login, Users'
                  
    respond_to do |format|
      format.html
    end
  end
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      if user.activated?
        session[:user_id] = user.id
        flash[:notice] = "Login successful!"
        if params[:remember] == "on"
          user.remember
          cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires }
        end
      else
        flash[:error] = "Please activate your account before logging in."
      end
    else
      flash[:error] = "Invalid user/password combination."
    end

    respond_to do |format|
      format.html { redirect_to session[:original_uri] || params[:original_uri] || :root }
    end
  end
  
  def destroy
    current_user.forget
    reset_session
    flash[:notice] = "Logged out."

    respond_to do |format|
      format.html { redirect_to request.referrer || :root }
    end
  end
end
