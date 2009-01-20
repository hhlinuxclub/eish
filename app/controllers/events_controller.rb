class EventsController < ApplicationController
  skip_before_filter :authorize
  caches_page :index, :if => Proc.new { |c| c.request.format.ics? }
  
  # GET /events
  # GET /events.xml
  # GET /events.ics
  def index
    today = Date.today.to_s(:db)
    now = DateTime.now.to_s(:db)
    
    condition_for_ongoing = "starts_at < '" + now  + "' AND ends_at > '" + now + "'"
    
    @upcoming_events = Event.find_all_by_published(true, :conditions => "starts_at > '#{today} 00:00:00'", :order => "starts_at")
    @ongoing_events = Event.find_all_by_published(true, :conditions => condition_for_ongoing, :order => "starts_at")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @upcoming_events }
      format.ics # index.ics.erb
    end
  end
  
  # GET /events/past
  # GET /events/past.xml
  def past
    now = DateTime.now.to_s(:db)
    @past_events = Event.find_all_by_published(true, :conditions => "ends_at < '#{now}'", :order => "starts_at DESC")
    
    respond_to do |format|
      format.html # past.html.erb
      format.xml { render :xml => @past_events }
    end
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @event }
    end
  end
end
