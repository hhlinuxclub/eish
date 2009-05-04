class Gallery < ActiveRecord::Base
  belongs_to :user
  has_many :assets, :as => :attachable
  
  validates_presence_of :name, :description
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def publish(status=true)
    update_attributes(:published => status)
  end
end
