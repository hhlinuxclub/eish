module EventsHelper
  def format_event_dates(event)
    if (event.starts_at.to_date == event.ends_at.to_date)
      if (event.starts_at.hour == 0 && event.starts_at.min == 0 && event.ends_at.hour == 23 && event.ends_at.min == 59)
        return event.starts_at.strftime("%d %B %Y")
      else
        return event.starts_at.strftime("%d %B %Y, %H:%M") + " – " + event.ends_at.strftime("%H:%M")
      end
    else
       return event.starts_at.strftime("%d %B %Y, %H:%M") + " – " + event.ends_at.strftime("%d %B %Y, %H:%M")
    end
  end
end
