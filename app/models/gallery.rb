class Gallery < ActiveRecord::Base
  belongs_to :user
  has_many :assets, :as => :attachable
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
