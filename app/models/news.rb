class News < ActiveRecord::Base
  belongs_to :user
  
  def published
    return find_all_by_published(true)
  end
end
