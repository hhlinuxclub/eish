class Admin::EventsController < ApplicationController
  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy, :publish, :unpublish]
  
  def index
    @events = Event.find(:all)

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

    respond_to do |format|
      format.html
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    
    if params[:event][:all_day] == "1"
      @event.starts_at = Time.local(@event.starts_at.year, @event.starts_at.month, @event.starts_at.day, 0, 0, 0)
      @event.ends_at = Time.local(@event.ends_at.year, @event.ends_at.month, @event.ends_at.day + 1, 0, 0, 0)
    end
    
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(admin_event_path(@event)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    
    if params[:event][:all_day] == "1"
      @event.ends_at = @event.ends_at + 86400
      params[:event]["starts_at(1i)"] = @event.starts_at.year.to_s
      params[:event]["starts_at(2i)"] = @event.starts_at.month.to_s
      params[:event]["starts_at(3i)"] = @event.starts_at.day.to_s
      params[:event]["starts_at(4i)"] = "0"
      params[:event]["starts_at(5i)"] = "0"
      params[:event]["ends_at(1i)"] = @event.ends_at.year.to_s
      params[:event]["ends_at(2i)"] = @event.ends_at.month.to_s
      params[:event]["ends_at(3i)"] = @event.ends_at.day.to_s
      params[:event]["ends_at(4i)"] = "0"
      params[:event]["ends_at(5i)"] = "0"
    end

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(admin_event_path(@event)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(admin_events_url) }
    end
  end
  
  def publish
    event = Event.find(params[:id])
    event.published = true
    
    respond_to do |format|
      if event.save
        flash[:notice] = "The event is now published."
      else
        flash[:notice] = "Some error occurred. Nothing was changed."
      end
      format.html { redirect_to(admin_event_path(event)) }
    end
  end
  
  def unpublish
    event = Event.find(params[:id])
    event.published = false
    
    respond_to do |format|
      if event.save
        flash[:notice] = "The event is now unpublished."
      else
        flash[:notice] = "Some error occurred. Nothing was changed."
      end
      format.html { redirect_to(admin_event_path(event)) }
    end
  end
end
