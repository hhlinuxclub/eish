class News < ActiveRecord::Base
  xapit(:conditions => { :published => true }) do |index|
    index.text :title, :body
  end

  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :assets, :as => :attachable
  
  validates_presence_of :title, :body
  
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
