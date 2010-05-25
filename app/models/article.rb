class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :image, :class_name => "Asset"
  has_many :revisions
  has_many :categorizations
  has_many :categories, :through => :categorizations
  has_many :assets, :as => :attachable
  
  validates_presence_of :title, :description, :body
  
  named_scope :all_published, :conditions => { :published => true }, :order => "published_at DESC" # legacy scope
  named_scope :published, :conditions => { :published => true }, :order => "published_at DESC"
  named_scope :unpublished, :conditions => { :published => true }
  named_scope :for_user, lambda { |user|
      { :conditions => { :user_id => user.id } }
  }
  
  attr_accessor :updated_by_user_id
  
  def before_create
    self.current_revision_id = 1
  end
  
  def before_save
    self.published_at ||= Time.now if self.published?
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
  
  def self.statistics
    {:total => self.count, :published => self.count(:all, :conditions => { :published => true }), :unpublished => self.count(:all, :conditions => { :published => false })}
  end
end
