class Admin::EventsController < AdministrationController 
  def index    

    @events = Event.find_all_for_user(current_user, :order => "id DESC")

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

    @event = Event.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.all_day = @event.all_day?
    
 
    respond_to do |format|
      if @event.editable?(current_user)
        format.html
      else
        format.html { redirect_to admin_events_path}
      end
    end
  end

  def create
    @event = Event.new(params[:event])
    @event.user_id = current_user_id
    @asset = @event.assets.build(params[:asset].merge!(:user_id => current_user_id)) if params[:upload]
    
    respond_to do |format|
      if params[:preview]
        format.html { render :action => "new" }
      else
        if @event.save
          flash[:notice] = "Event successfully created."
          format.html { redirect_to edit_admin_event_path @event }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    
    redirect_to admin_events_path and return unless @event.editable?(current_user)
    
    if params[:upload]
      @asset = @event.assets.create(params[:asset].merge!(:user_id => current_user_id))
    elsif params[:destroy_asset]
      Asset.find(params[:destroy_asset]).destroy
    else
      if params[:image] == "nil"
        @event.image = nil
      else
        @event.image_id = params[:image]
      end
    end
      
    @event.attributes = params[:event]

    respond_to do |format|
      if params[:upload] || params[:destroy_asset] || params[:preview]
        format.html { render :action => "edit" }
      else
        if @event.save
          flash[:notice] = "Event was successfully updated."
          format.html { redirect_to admin_event_path @event }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    
    if current_user.role.can_delete?
      if @event.destroy
        flash[:notice] = "Event was successfully deleted."
      else
        flash[:error] = "Some error happened. The event was not deleted."
      end
    end

    respond_to do |format|
      format.html { redirect_to admin_events_path }
    end
  end
  
  def bulk_action
    unless params[:events].nil?
      selected = []
      params[:events].each { |id, value| selected << id if value == "on" }
      events = Event.find(selected)
    
      case params[:actions]
        when "delete"
          events.each { |e| e.destroy } if current_user.role.can_delete?
        when "publish"
          events.each { |e| e.update_attribute(:published, true) } if current_user.role.can_publish?
        when "unpublish"
          events.each { |e| e.update_attribute(:published, false) } if current_user.role.can_publish?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_events_path }
    end
  end
  
  def unpublish
    event = Event.find(params[:id])
    
    event.update_attribute(:published, false) if current_user.role.can_publish?
    
    respond_to do |format|
      flash[:notice] = "The event was unpublished."
      format.html { redirect_to admin_events_path }
    end
  end
  
  def publish
    event = Event.find(params[:id])
    
    event.update_attribute(:published, true) if current_user.role.can_publish?
    
    respond_to do |format|
      flash[:notice] = "The event was published."
      format.html { redirect_to admin_events_path }
    end
  end
end
