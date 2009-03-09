class Article < ActiveRecord::Base
  belongs_to :user
  
  named_scope :all_published, :conditions => { :published => true }
end
