class Gallery < ActiveRecord::Base
  belongs_to :user
  has_many :assets, :as => :attachable
  
  validates_presence_of :name, :description
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
