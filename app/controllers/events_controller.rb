class EventsController < ApplicationController
  skip_before_filter :authorize
  caches_page :index, :if => Proc.new { |c| c.request.format.ics? }
  
  # GET /events
  # GET /events.xml
  # GET /events.ics
  def index
    @upcoming_events = Event.upcoming
    @ongoing_events = Event.ongoing
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @upcoming_events }
      format.ics # index.ics.erb
      format.atom
    end
  end
  
  # GET /events/past
  # GET /events/past.xml
  def past
    @past_events = Event.past
    
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
