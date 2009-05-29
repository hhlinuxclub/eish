class AddDefaultImageToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :image_id, :string
  end

  def self.down
    remove_column :galleries, :image_id
  end
end
