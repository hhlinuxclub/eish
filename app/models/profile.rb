class Profile < ActiveRecord::Base
  belongs_to :user
  
  validates_numericality_of :graduation_year, :allow_nil => true
  
  def before_save
    self.url = "http://" + self.url unless self.url.nil? || self.url.empty? || self.url =~ /http(s)?:\/\/.*/
  end
end
