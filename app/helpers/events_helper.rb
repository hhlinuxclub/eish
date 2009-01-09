module EventsHelper
  def format_event_dates(event)
    # If all day
    if event.starts_at.hour == 0 && event.starts_at.min == 0 && event.ends_at.hour == 23 && event.ends_at.min == 59
      # If one day
      if event.starts_at.to_date == event.ends_at.to_date
        return event.starts_at.strftime("%d %B %Y")
      # If several days
      else
        return event.starts_at.strftime("%d %B %Y") + " – " + event.ends_at.strftime("%d %B %Y")
      end
    # If not all day
    else
      # If one day
      if event.starts_at.to_date == event.ends_at.to_date
        return event.starts_at.strftime("%d %B %Y, %H:%M") + " – " + event.ends_at.strftime("%H:%M")
      # If several days
      else
        return event.starts_at.strftime("%d %B %Y, %H:%M") + " – " + event.ends_at.strftime("%d %B %Y, %H:%M")
      end
    end
  end
end
