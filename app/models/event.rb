class Event < ActiveRecord::Base
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
    self.starts_at < Time.now
  end
  
  def self.upcoming(limit=nil)
    find_all_by_published(true, :conditions => ["starts_at > ?", Time.now.to_s(:db)], :order => "starts_at", :limit => limit)
  end
  
  def self.ongoing(limit=nil)
    now = Time.now.to_s(:db)
    find_all_by_published(true, :conditions => "starts_at < '#{now}' AND ends_at > '#{now}'", :order => "starts_at", :limit => limit)
  end
  
  def self.available(limit=nil)
    find_all_by_published(true, :conditions => ["ends_at > ?", Time.now.to_s(:db)], :order => "starts_at", :limit => limit)
  end
  
  def self.past(limit=nil)
    find_all_by_published(true, :conditions => ["ends_at < ?", Time.now.to_s(:db)], :order => "starts_at DESC", :limit => limit)
  end
  
  def all_day?
    self.starts_at.hour == 0 && self.starts_at.min == 0 && self.ends_at.hour == 0 && self.ends_at.min == 0
  end
  
  def before_save
    if all_day == "1" || all_day == true
      start_date = starts_at.to_date
      self.starts_at = start_date
      self.ends_at = start_date + 1
    end
    self.published_at ||= Time.now if self.published?
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
  
  def self.statistics
    {:total => self.count, :published => self.count(:all, :conditions => { :published => true }), :unpublished => self.count(:all, :conditions => { :published => false })}
  end
    
  private
  
    def date_range_and_format
      starts = []
      ends = [] 
      self.starts_at_date = self.starts_at_date.split(/[\.|\/]/).reverse
      self.starts_at_time = self.starts_at_time.split(":")
      self.ends_at_date = self.ends_at_date.split(/[\.|\/]/).reverse
      self.ends_at_time = self.ends_at_time.split(":")
      starts = starts + starts_at_date if starts_at_date.size == 3
      starts = starts + starts_at_time if starts_at_time.size == 2
      ends = ends + ends_at_date if ends_at_date.size == 3
      ends = ends + ends_at_time if ends_at_time.size == 2
      
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
