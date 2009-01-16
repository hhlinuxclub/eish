class Event < ActiveRecord::Base
  belongs_to :user
  
  attr_accessor :all_day
  
  def is_ongoing?
    return self.starts_at < DateTime.now
  end
  
  def self.upcoming(limit)
    return Event.find_all_by_published(true, :conditions => "ends_at > '#{DateTime.now.to_s(:db)}'", :order => "starts_at", :limit => limit)
  end
  
  def all_day?
    if self.starts_at.hour == 0 && self.starts_at.min == 0 && self.ends_at.hour == 0 && self.ends_at.min == 0
      return true
    else
      return false
    end
  end
  
  def self.all_to_ical
    require 'icalendar'
    
    calendar = Icalendar::Calendar.new
    calendar.prodid = "hhlc.eish!"
    
    timezone = Icalendar::Timezone.new
    daylight = Icalendar::Daylight.new
    standard = Icalendar::Standard.new
    
    timezone.timezone_id =            "Europe/Helsinki"

    daylight.timezone_offset_from =   "+0200"
    daylight.timezone_offset_to =     "+0300"
    daylight.timezone_name =          "EEST"
    daylight.dtstart =                "19700329T030000"
    daylight.recurrence_rules =       ["FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU"]

    standard.timezone_offset_from =   "+0300"
    standard.timezone_offset_to =     "+0200"
    standard.timezone_name =          "EET"
    standard.dtstart =                "19701025T040000"
    standard.recurrence_rules =       ["FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU"]

    timezone.add daylight
    timezone.add standard
    
    calendar.add timezone
    
    Event.find_all_by_published(true).each do |e|
      event = Icalendar::Event.new
      
      event.start = e.starts_at.to_datetime
      event.end = e.ends_at.to_datetime
      if e.all_day?
        event.start Date.parse( event.start.to_s ), {"VALUE" => ["DATE"]}
        event.end Date.parse( event.end.to_s ), {"VALUE" => ["DATE"]}
      end
      event.summary = e.name
      event.description = e.description # FIXME: Strip textile
      
      calendar.add event
    end
    
    return calendar.to_ical
  end
end
