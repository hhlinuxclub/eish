class Admin::GalleriesController < ApplicationController
  layout "admin"
  
  def index
    user = User.find(session[:user_id])
    
    set_meta_tags :title => "Galleries"
    
    if user.role.can_update? || user.role.can_delete? || user.role.can_publish? || user.role.can_administer?
      @galleries = Gallery.find(:all, :order => "id DESC")
    else
      @galleries = Gallery.find_all_by_user_id(user.id, :order => "id DESC")
    end
    
    respond_to do |format|
      format.html
    end
  end

  def show
    redirect_to :action => "edit"
  end

  def new
    @gallery = Gallery.new
    user = User.find(session[:user_id])
    
    redirect_to admin_galleries_path and return unless user.role.can_create?
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
    user = User.find(session[:user_id])
    
    if !user.role.can_update? && user.id != @gallery.user_id
      redirect_to admin_galleries_path and return
    end
    
    set_meta_tags :title => "Editing '" + @gallery.name + "'"
    
    respond_to do |format|
      format.html
    end
  end

  def create
    user = User.find(session[:user_id])
    
    redirect_to admin_galleries_path and return unless user.role.can_create?
    
    @gallery = Gallery.new(params[:gallery])
    @gallery.user_id = user.id
    
    respond_to do |format|
      if @gallery.save
        flash[:notice] = "Gallery successfully created."
        format.html { redirect_to edit_admin_gallery_path @gallery }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @gallery = Gallery.find(params[:id])
    user = User.find(session[:user_id])
    
    if !user.role.can_update? && @gallery.user_id != user.id
      redirect_to admin_galleries_path and return
    end
    
    if params[:upload]
      @gallery.attributes = params[:gallery]
      @gallery.images.create(params[:asset].merge!(:user_id => user.id))
    elsif params[:destroy_image]
      Image.find(params[:destroy_image]).destroy
    end
    
    respond_to do |format|
      if params[:upload] || params[:destroy_image]
        format.html { render :action => "edit" }
      else
        if @gallery.update_attributes(params[:gallery])
          flash[:notice] = "Gallery was successfully updated."
          format.html { redirect_to edit_admin_gallery_path @gallery }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end

  def bulk_action
    unless params[:galleries].nil?
      selected = []
      params[:galleries].each { |id, value| selected << id if value == "on" }
      galleries = Gallery.find(selected)
      user = User.find(session[:user_id])
    
      case params[:actions]
        when "delete"
          galleries.each { |g| g.destroy } if user.role.can_delete?
        when "publish"
          galleries.each { |g| g.publish } if user.role.can_publish?
        when "unpublish"
          galleries.each { |g| g.publish(false) } if user.role.can_publish?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_galleries_path }
    end
  end
end
