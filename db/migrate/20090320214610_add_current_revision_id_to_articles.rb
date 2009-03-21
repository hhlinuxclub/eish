class AddCurrentRevisionIdToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :current_revision_id, :integer
  end

  def self.down
    remove_column :articles, :current_revision_id
  end
end
