class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
  
  named_scope :all_alphabetically, :order => "name"
  
  validates_uniqueness_of :name
end
