class Admin::EventsController < ApplicationController
  layout "admin"
 
  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy, :publish, :unpublish]
  
  def index
    user = User.find(session[:user_id], :include => :role)
    if user.role.can_update? || user.role.can_delete? || user.role.can_publish? || user.role.can_administer?
      @events = Event.find(:all, :order => "created_at DESC")
    else
      @events = Event.find_all_by_user_id(user.id, :order => "created_at DESC")
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @events }
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = Event.new
    user = User.find(session[:user_id])

    respond_to do |format|
      if user.role.can_create?
        format.html
      else
        format.html { redirect_to admin_events_path }
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.all_day = @event.all_day?
    user = User.find(session[:user_id])
    
    respond_to do |format|
      if user.role.can_update? || user.id == @event.user_id
        format.html
      else
        format.html { redirect_to admin_events_path}
      end
    end
  end

  def create
    @event = Event.new(params[:event])
    @event.user_id = session[:user_id]
    user = User.find(session[:user_id])
    
    if params[:event][:all_day] == "1"
      @event.starts_at = Time.local(@event.starts_at.year, @event.starts_at.month, @event.starts_at.day, 0, 0, 0)
      @event.ends_at = @event.starts_at + 86400
    end
    
    respond_to do |format|
      if user.role.can_create?
        if @event.save
          flash[:notice] = 'Event was successfully created.'
          format.html { redirect_to(admin_event_path(@event)) }
        else
          format.html { render :action => "new" }
        end
      else
        format.html { redirect_to admin_events_path }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    user = User.find(session[:user_id])

    respond_to do |format|
      if user.role.can_update? || user.id == @event.user_id
        if @event.update_attributes(params[:event])
          flash[:notice] = 'Event was successfully updated.'
          format.html { redirect_to(admin_event_path(@event)) }
        else
          format.html { render :action => "edit" }
        end
      else
        format.html { redirect_to admin_events_path }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    user = User.find(session[:user_id])
    
    if user.role.can_delete?
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
  
  def preview
    render :layout => false
  end
  
  def bulk_action
    unless params[:events].nil?
      selected = []
      params[:events].each { |id, value| selected << id if value == "on" }
      events = Event.find(selected)
      user = User.find(session[:user_id])
    
      case params[:actions]
        when "delete"
          events.each { |e| e.destroy } if user.role.can_delete?
        when "publish"
          events.each { |e| e.publish } if user.role.can_publish?
        when "unpublish"
          events.each { |e| e.publish(false) } if user.role.can_publish?
      end
    end
    
    respond_to do |format|
      format.html { redirect_to admin_events_path }
    end
  end
end
