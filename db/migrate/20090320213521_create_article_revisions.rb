class CreateArticleRevisions < ActiveRecord::Migration
  def self.up
    create_table :article_revisions do |t|
      t.integer :revision
      t.string :title
      t.string :description
      t.text :body
      t.integer :article_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :article_revisions
  end
end
