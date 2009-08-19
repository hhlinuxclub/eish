class Setting < ActiveRecord::Base
  def self.option(option, type=:text)
    include ActiveRecord::ConnectionAdapters
    value = find_by_option(option).value
    case type
      when :integer   then value.to_i
      when :boolean   then Column.value_to_boolean(value)
      else value 
    end
  end
  
  def self.featured_article_id
    option("featured_article").to_i
  end
end
