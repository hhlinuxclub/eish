class SessionsController < ApplicationController
  def new
    set_meta_tags :title => 'Login',
                  :description => 'Login page',
                  :keywords => 'Site, Login, Users'
                  
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @user = User.authenticate(params[:username], params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "Login successful!"
      if params[:remember_me] == "on"
        @user.remember_me
        cookies[:auth_token] = { :value => @user.remember_token, :expires => @user.remember_token_expires }
      end
    else
      flash[:error] = "Invalid user/password combination."
    end

    respond_to do |format|
      format.html { redirect_to :back || :root }
    end
  end
  
  def destroy
    User.find(session[:user_id]).forget_me
    reset_session
    flash[:notice] = "Logged out."

    respond_to do |format|
      format.html { redirect_to request.referrer || :root }
    end
  end
end
