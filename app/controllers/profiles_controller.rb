class ProfilesController < ApplicationController
  def show
    @user = User.find(:first, :conditions => { :username => params[:id] })
    
    raise ActiveRecord::RecordNotFound if @user.nil?
    
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @user = User.find(:first, :conditions => { :username => params[:id] })
    
    raise ActiveRecord::RecordNotFound if @user.nil?
    
    redirect_to profile_path @user and return unless @user.id == current_user_id
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    redirect_to profile_path @user and return unless @user.id == current_user_id
    
    respond_to do |format|
      if @user.profile.update_attributes(params[:profile])
        format.html { redirect_to profile_path @user }
      else
        format.html { render :action => "show" }
      end
    end
  end
end
