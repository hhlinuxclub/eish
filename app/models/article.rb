class Article < ActiveRecord::Base
  belongs_to :user
  
  def self.all_published
    return find_all_by_published(true)
  end
end
