class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :assets, :as => :attachable
  
  validates_presence_of :title, :body
  
  named_scope :published, :conditions => { :published => true }, :order => "published_at DESC"
  named_scope :unpublished, :conditions => { :published => true }
  named_scope :for_user, lambda { |user|
      { :conditions => { :user_id => user.id } }
  }
  
  def before_save
    self.published_at ||= Time.now if self.published?
  end
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def images
    Asset.images("News", id)
  end
  
  def files
    Asset.files("News", id)
  end
  
  def self.statistics
    {:total => self.count, :published => self.count(:all, :conditions => { :published => true }), :unpublished => self.count(:all, :conditions => { :published => false })}
  end
end
