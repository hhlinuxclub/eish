class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :revisions
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :assets, :as => :attachable
  
  validates_presence_of :title, :description, :body
  
  named_scope :all_published, :conditions => { :published => true }
  
  attr_accessor :updated_by_user_id
  
  if SEARCH_ENABLED
    xapit(:conditions => { :published => true }) do |index|
      index.text :title, :weight => 3
      index.text :description, :weight => 2
      index.text :body, :weight => 1
      index.facet :author_name, "Author"
    end
  end
  
  def before_create
    self.current_revision_id = 1
  end
  
  def after_create
    Revision.create :number => 1, :title => title, :description => description, :body => body, :user_id => user_id, :article_id => id
  end
  
  def before_destroy
    return false if Setting.option("featured_article").to_i == id
  end
  
  def change_to_revision(number)
    revision = Revision.find_by_article_id_and_number(self.id, number)
    self.title = revision.title
    self.description = revision.description
    self.body = revision.body
    self.current_revision_id = number
    self.save_without_validation
  end
  
  def after_validation_on_update
    if title != current_revision.title || description != current_revision.description || body != current_revision.body
      latest_revision = Revision.maximum(:number, :conditions => "article_id = #{id}") || 0
      self.current_revision_id = latest_revision + 1
      Revision.create :number => latest_revision + 1, :title => title, :description => description, :body => body, :user_id => updated_by_user_id, :article_id => id
    end
  end
  
  def publish(status=true)
    self.published = status
    self.save_without_validation
  end
  
  def current_revision
    return Revision.find_by_article_id_and_number(id, current_revision_id)
  end
  
  def images
    Asset.images("Article", id)
  end
  
  def files
    Asset.files("Article", id)
  end
  
  def self.featured
    featured_article_id = Setting.option("featured_article")
    if featured_article_id.nil? || featured_article_id.empty?
      return nil
    else
      return Article.find(featured_article_id)
    end
  end
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def author_name
    self.user.name
  end
end
