class News < ActiveRecord::Base
  belongs_to :user
  
  def self.published
    return find_all_by_published(true)
  end
end
