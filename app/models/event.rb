class Event < ActiveRecord::Base
  belongs_to :user
  
  def is_ongoing?
    return self.starts_at < DateTime.now
  end
  
  def self.upcoming(limit)
    return Event.find(:all, :conditions => "ends_at > '#{DateTime.now.to_s(:db)}'", :order => "starts_at", :limit => limit)
  end
end
