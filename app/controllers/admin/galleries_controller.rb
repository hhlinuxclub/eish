class Admin::GalleriesController < AdministrationController
  def index    

    @galleries = Gallery.find_all_for_user(current_user, :order => "id DESC")
    
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html { redirect_to :action => "edit" }
    end
  end

  def new
    @gallery = Gallery.new
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
    @asset = Image.new
    
    redirect_to admin_galleries_path and return unless @gallery.editable?(current_user)
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    @gallery.user_id = current_user_id
    
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
    
    redirect_to admin_galleries_path and return unless @gallery.editable?(current_user)
    
    if params[:upload]
      @asset = @gallery.images.create(params[:image].merge!(:user_id => current_user_id))
      @gallery.update_attribute(:image_id, @asset.id) if @gallery.image.nil?
    elsif params[:destroy_image]
      Image.find(params[:destroy_image]).destroy
    else
      @gallery.image_id = params[:selected_image]
    end
    
    @gallery.attributes = params[:gallery]
    
    respond_to do |format|
      if params[:upload] || params[:destroy_image]
        format.html { render :action => "edit" }
      else
        if @gallery.save
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
    
      case params[:actions]
        when "delete"
          galleries.each { |g| g.destroy } if current_user.role.can_delete?
        when "publish"
          galleries.each { |g| g.update_attribute(:published, true) } if current_user.role.can_publish?
        when "unpublish"
          galleries.each { |g| g.update_attribute(:published, false) } if current_user.role.can_publish?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_galleries_path }
    end
  end
  
  def unpublish
    gallery = Gallery.find(params[:id])
    
    gallery.update_attribute(:published, false) if current_user.role.can_publish?
    
    respond_to do |format|
      flash[:notice] = "The gallery was unpublished."
      format.html { redirect_to admin_galleries_path }
    end
  end
  
  def publish
    gallery = Gallery.find(params[:id])
    
    gallery.update_attribute(:published, true) if current_user.role.can_publish?
    
    respond_to do |format|
      flash[:notice] = "The gallery was published."
      format.html { redirect_to admin_galleries_path }
    end
  end
end
