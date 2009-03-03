class Setting < ActiveRecord::Base
  def self.option(option)
    return find_by_option(option).value
  end
end
