class Setting < ActiveRecord::Base
  def self.option(option)
    find_by_option(option).value
  end
  
  def self.featured_article_id
    option("featured_article").to_i
  end
end
