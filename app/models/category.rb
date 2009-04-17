class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :articles, :through => :categorizations
  
  named_scope :all_alphabetically, :order => "name"
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def published_articles
    articles.find(:all, :conditions => { :published => true })
  end
end
