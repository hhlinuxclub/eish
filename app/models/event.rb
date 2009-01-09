class Event < ActiveRecord::Base
  belongs_to :user
  
  attr_accessor :all_day
  
  def is_ongoing?
    return self.starts_at < DateTime.now
  end
  
  def self.upcoming(limit)
    return Event.find_all_by_published(true, :conditions => "ends_at > '#{DateTime.now.to_s(:db)}'", :order => "starts_at", :limit => limit)
  end
end
