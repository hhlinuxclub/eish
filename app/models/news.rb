class News < ActiveRecord::Base
  acts_as_ferret :fields => {
        :title => {:boost => 2}, 
        :body => {:boost => 1}
      }
      
  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :assets, :as => :attachable
  
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
