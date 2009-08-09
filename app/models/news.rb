class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :assets, :as => :attachable
  
  validates_presence_of :title, :body
    
  if SEARCH_ENABLED
    xapit(:conditions => { :published => true }) do |index|
      index.text :title, :weight => 3
      index.text :body, :weight => 2
    end
  end
  
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
end
