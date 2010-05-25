class Gallery < ActiveRecord::Base
  belongs_to :user
  belongs_to :image
  has_many :images, :as => :attachable
  
  validates_presence_of :name, :description
  
  named_scope :published, :conditions => { :published => true }
  named_scope :not_null, :conditions => "image_id IS NOT NULL", :order => "published_at DESC"
  named_scope :for_user, lambda { |user|
      { :conditions => { :user_id => user.id } }
  }
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def before_save
    self.published_at ||= Time.now if self.published?
  end
  
  def self.statistics
    {:total => self.count, :published => self.count(:all, :conditions => { :published => true }), :unpublished => self.count(:all, :conditions => { :published => false })}
  end
end
