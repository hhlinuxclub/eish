class RenameArticleRevisionsToRevisions < ActiveRecord::Migration
  def self.up
    rename_table :article_revisions, :revisions
  end

  def self.down
    rename_table :revisions, :article_revisions
  end
end
