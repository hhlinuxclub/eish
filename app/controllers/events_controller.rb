class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    @upcoming_events = Event.published.upcoming
    @ongoing_events = Event.published.ongoing
    
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
    @past_events = Event.published.past
    
    set_meta_tags :title => "Past Events",
                  :description => "Past events related to the club",
                  :keywords => "events, past"
    
    respond_to do |format|
      format.html # past.html.erb
    end
  end
    
  def show
    @event = Event.published.find(params[:id].to_i)
    
    set_meta_tags :title => @event.name,
                  :description => "An event related to the club",
                  :keywords => "events"
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
