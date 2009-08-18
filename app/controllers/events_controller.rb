class EventsController < ApplicationController
  before_filter :require_http
  
  # GET /events
  # GET /events.xml
  def index
    @upcoming_events = Event.upcoming
    @ongoing_events = Event.ongoing
    
    set_meta_tags :title => "Events",
                  :description => "Events related to the club",
                  :keywords => "events"
    
    respond_to do |format|
      format.html # index.html.erb
      format.atom { @latest_update = Event.maximum("updated_at") || Time.now }
    end
  end
  
  # GET /events/past
  # GET /events/past.xml
  def past
    @past_events = Event.past
    
    set_meta_tags :title => "Past Events",
                  :description => "Past events related to the club",
                  :keywords => "events, past"
    
    respond_to do |format|
      format.html # past.html.erb
    end
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id].to_i)
    
    set_meta_tags :title => @event.name,
                  :description => "An event related to the club",
                  :keywords => "events"
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
