class AddImagesToContent < ActiveRecord::Migration
  def self.up
    add_column :articles, :image_id, :integer
    add_column :news, :image_id, :integer
    add_column :events, :image_id, :integer
  end

  def self.down
    remove_column :events, :image_id
    remove_column :news, :image_id
    remove_column :articles, :image_id
  end
end
