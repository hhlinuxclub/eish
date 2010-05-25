class EventsController < ApplicationController
  def index
    @upcoming_events = Event.published.upcoming
    @ongoing_events = Event.published.ongoing
    
    respond_to do |format|
      format.html
      format.atom { @latest_update = Event.maximum("updated_at") || Time.now }
    end
  end
  
  def past
    @past_events = Event.published.past
    
    respond_to do |format|
      format.html
    end
  end
    
  def show
    @event = Event.published.find(params[:id].to_i)
    
    respond_to do |format|
      format.html
    end
  end
end
