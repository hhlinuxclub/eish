class Article < ActiveRecord::Base
  belongs_to :user
  has_many :article_revisions
  
  named_scope :all_published, :conditions => { :published => true }
  
  attr_accessor :updated_by_user_id
  
  def before_create
    self.current_revision_id = 1
  end
  
  def after_create
    ArticleRevision.create :revision => 1, :title => title, :description => description, :body => body, :user_id => user_id, :article_id => id
  end
  
  def change_to_revision(rev_number)
    revision = ArticleRevision.find_by_article_id_and_revision(self.id, rev_number)
    self.title = revision.title
    self.description = revision.description
    self.body = revision.body
    self.current_revision_id = rev_number
    self.save_without_validation
  end
  
  def after_validation_on_update
    if title != current_revision.title || description != current_revision.description || body != current_revision.body
      latest_revision = ArticleRevision.maximum(:revision, :conditions => "article_id = #{id}") || 0
      self.current_revision_id = latest_revision + 1
      ArticleRevision.create :revision => latest_revision + 1, :title => title, :description => description, :body => body, :user_id => updated_by_user_id, :article_id => id
    end
  end
  
  def publish(status=true)
    self.published = status
    self.save_without_validation
  end
  
  def current_revision
    return ArticleRevision.find_by_article_id_and_revision(id, current_revision_id)
  end
end
