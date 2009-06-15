class ProfilesController < ApplicationController
  def show
    @user = User.find_by_username(params[:id])
    
    set_meta_tags :title => @user.username,
                  :description => 'Profile page',
                  :keywords => 'Profile, Users'
    
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @user = User.find_by_username(params[:id])
    
    redirect_to profile_path @user and return unless @user.id == session[:user_id]
    
    set_meta_tags :title => @user.username,
                  :description => 'Profile page',
                  :keywords => 'Profile, Users'
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    redirect_to profile_path @user and return unless @user.id == session[:user_id]
    
    respond_to do |format|
      if @user.profile.update_attributes(params[:profile])
        format.html { redirect_to profile_path @user }
      else
        format.html { render :action => "show" }
      end
    end
  end
end
