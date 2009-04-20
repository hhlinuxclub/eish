class EventsController < ApplicationController
  skip_before_filter :authorize
  caches_page :index, :if => Proc.new { |c| c.request.format.ics? }
  
  # GET /events
  # GET /events.xml
  # GET /events.ics
  def index
    @upcoming_events = Event.upcoming
    @ongoing_events = Event.ongoing
    
    @meta_title = "Events"
    @meta_description = "Events related to the club"
    @meta_keywords = @meta_keywords + ", events"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @upcoming_events }
      format.ics # index.ics.erb
      format.atom { @latest_update = Event.maximum("updated_at") || Time.now }
    end
  end
  
  # GET /events/past
  # GET /events/past.xml
  def past
    @past_events = Event.past
    
    @meta_title = "Past Events"
    @meta_description = "Past events related to the club"
    @meta_keywords = @meta_keywords + ", events, past"
    
    respond_to do |format|
      format.html # past.html.erb
      format.xml { render :xml => @past_events }
    end
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id].to_i)
    
    @meta_title = @event.name
    @meta_description = "An event related to HHLunuxClub"
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @event }
    end
  end
end
