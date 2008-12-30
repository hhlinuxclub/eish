class Image < ActiveRecord::Base
  has_and_belongs_to_many :galleries
  belongs_to :user
end
