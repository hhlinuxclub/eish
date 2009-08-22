class Setting < ActiveRecord::Base
  def self.option(option, type=:text)
    return unless self.table_exists?

    include ActiveRecord::ConnectionAdapters
    setting = find_by_option(option)
    value = setting.nil? ? nil : setting.value
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
