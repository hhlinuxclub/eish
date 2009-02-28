module EventsHelper
  def format_event_dates(event)
    # If all day
    if event.all_day?
      # If one day
      event.ends_at = event.ends_at - 86400
      if event.starts_at.to_date == event.ends_at.to_date
        return event.starts_at.strftime("%d %B %Y")
      # If several days
      else
        return event.starts_at.strftime("%d %B %Y") + " &mdash; " + event.ends_at.strftime("%d %B %Y")
      end
    # If not all day
    else
      # If one day
      if event.starts_at.to_date == event.ends_at.to_date
        return event.starts_at.strftime("%d %B %Y, %H:%M") + " &mdash; " + event.ends_at.strftime("%H:%M")
      # If several days
      else
        return event.starts_at.strftime("%d %B %Y, %H:%M") + " &mdash; " + event.ends_at.strftime("%d %B %Y, %H:%M")
      end
    end
  end
end
