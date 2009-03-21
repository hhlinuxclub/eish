class Article < ActiveRecord::Base
  belongs_to :user
  has_many :article_revisions
  
  named_scope :all_published, :conditions => { :published => true }
  
  def before_create
    self.current_revision_id = 1
  end
  
  def after_create
    ArticleRevision.create :revision => 1, :title => title, :description => description, :body => body, :user_id => user_id, :article_id => id
  end
  
  def change_to_revision(rev_number)
    revision = ArticleRevision.find_by_article_id_and_revision(self.id, rev_number)
    self.update_attributes :title => revision.title, :description => revision.description, :body => revision.body, :current_revision_id => rev_number
  end
  
  def before_update
    latest_revision = ArticleRevision.maximum(:revision, :conditions => "article_id = #{id}") || 0
    self.current_revision_id = latest_revision + 1
    ArticleRevision.create :revision => latest_revision + 1, :title => title, :description => description, :body => body, :user_id => user_id, :article_id => id
  end
end
