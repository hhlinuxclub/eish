class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :assets, :as => :attachable
  
  validates_presence_of :title, :body
  
  if SEARCH_ENABLED
    xapit(:conditions => { :published => true }) do |index|
      index.text :title, :body
    end
  end
  
  def publish(status=true)
    update_attributes(:published => status)
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
