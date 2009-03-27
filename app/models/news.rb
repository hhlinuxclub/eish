class News < ActiveRecord::Base
  belongs_to :user
  
  def publish(status=true)
    update_attributes(:published => status)
  end
end
