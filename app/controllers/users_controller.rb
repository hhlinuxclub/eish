class UsersController < ApplicationController
  skip_before_filter :authorize
  
  def login
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id
        original_uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(original_uri || :root)
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to :root
  end

  def profile
    @user = User.find(session[:user_id])
  end
  
  def register
    @user = User.new
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end
  
  def create
    @user = User.new(params[:user])
    @user.role_id = 5
    
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "User #{@user.username} was successfully created."
        format.html { redirect_to :root }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @user = User.find(session[:user_id])
    current_hashed_password = User.encrypted_password(params[:user][:current_password], @user.salt)

    respond_to do |format|
      if current_hashed_password == @user.hashed_password
        if @user.update_attributes(params[:user])
          flash[:notice] = "User #{@user.username} was successfully updated."
          format.html { redirect_to :action => "profile" }
          format.xml  { head :ok }
        else
          format.html { render :action => "profile" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      else
        flash[:notice] = "Old password is incorrect."
        format.html { redirect_to :action => "profile" }
      end
    end
  end
end
