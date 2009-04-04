class RenameArticleRevisionsToRevisions < ActiveRecord::Migration
  def self.up
    rename_table :article_revisions, :revisions
  end

  def self.down
  end
end
