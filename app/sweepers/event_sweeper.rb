class EventSweeper < ActionController::Caching::Sweeper
  observe Event
  
  def after_save(event)
    expire_page("/events.ics")
  end
  
  def after_destroy(event)
    expire_page("/events.ics")
  end
end