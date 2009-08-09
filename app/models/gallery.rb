class Gallery < ActiveRecord::Base
  belongs_to :user
  belongs_to :image
  has_many :images, :as => :attachable
  
  validates_presence_of :name, :description
  
  if SEARCH_ENABLED
    xapit(:conditions => { :published => true }) do |index|
      index.text :name, :weight => 2
      index.text :description, :weight => 1
    end
  end
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  def before_save
    self.published_at ||= Time.now if self.published?
  end
end
