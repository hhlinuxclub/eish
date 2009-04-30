class Event < ActiveRecord::Base
  xapit(:conditions => { :published => true }) do |index|
    index.text :name, :description
  end

  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :assets, :as => :attachable
  
  attr_accessor :all_day, :starts_at_date, :starts_at_time, :ends_at_date, :ends_at_time
  
  validates_presence_of :name, :description
  validates_presence_of :starts_at, :if => Proc.new { |event| event.starts_at_date.nil? || event.starts_at_time.nil? }
  validates_presence_of :ends_at, :if => Proc.new { |event| event.ends_at_date.nil? || event.ends_at_time.nil? }
  validates_presence_of :starts_at_date, :if => Proc.new { |event| event.starts_at.nil? }
  validates_presence_of :starts_at_time, :if => Proc.new { |event| event.starts_at.nil? }
  validates_presence_of :ends_at_date, :if => Proc.new { |event| event.ends_at.nil? }
  validates_presence_of :ends_at_time, :if => Proc.new { |event| event.ends_at.nil? }
  validate :date_range_and_format
  
  def ongoing?
    return self.starts_at < Time.now
  end
  
  def self.upcoming(limit=:all)
    if limit == :all
      return find_all_by_published(true, :conditions => ["starts_at > ?", Time.now.to_s(:db)], :order => "starts_at")
    else
      return find_all_by_published(true, :conditions => ["starts_at > ?", Time.now.to_s(:db)], :order => "starts_at", :limit => limit)
    end
  end
  
  def self.ongoing
    now = Time.now.to_s(:db)
    return find_all_by_published(true, :conditions => "starts_at < '#{now}' AND ends_at > '#{now}'", :order => "starts_at")
  end
  
  def self.past
    find_all_by_published(true, :conditions => "ends_at < '#{Time.now.to_s(:db)}'", :order => "starts_at DESC")
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
  
  def before_save
    if all_day == "1" || all_day == true
      start_date = starts_at.to_date
      self.starts_at = start_date
      self.ends_at = start_date + 1
    end
  end
  
  def publish(status=true)
    self.published = status
    self.save_without_validation
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def images
    Asset.images("Event", id)
  end
  
  def files
    Asset.files("Event", id)
  end
    
  private
  
    def date_range_and_format
      starts = []
      ends = [] 
      self.starts_at_date = self.starts_at_date.split(/[\.|\/]/).reverse
      self.starts_at_time = self.starts_at_time.split(":")
      self.ends_at_date = self.ends_at_date.split(/[\.|\/]/).reverse
      self.ends_at_time = self.ends_at_time.split(":")
      starts = starts + starts_at_date if starts_at_date.count == 3
      starts = starts + starts_at_time if starts_at_time.count == 2
      ends = ends + ends_at_date if ends_at_date.count == 3
      ends = ends + ends_at_time if ends_at_time.count == 2
      
      if !self.starts_at_date.nil? && !self.starts_at_time.nil?
        begin
          self.starts_at = Time.local(starts[0], starts[1], starts[2], starts[3], starts[4])
        rescue
          errors.add_to_base("Invalid start date and/or time")
        end
      end
      
      if !self.ends_at_date.nil? && !self.ends_at_time.nil?
        begin
          self.ends_at = Time.local(ends[0], ends[1], ends[2], ends[3], ends[4])
        rescue
          errors.add_to_base("Invalid end date and/or time")
        end
      end
      
      if !starts_at.nil? && !ends_at.nil? && ends_at < starts_at
        errors.add_to_base("The event cannot end before it starts")
      end
    end
end
