class CreateGalleriesImages < ActiveRecord::Migration
  def self.up
    create_table :galleries_images, :id => false do |t|
      t.integer :gallery_id
      t.integer :image_id
    end
    
     add_index :galleries_images, [:gallery_id, :image_id], :unique => true
     add_index :galleries_images, :gallery_id, :unique => false
     add_index :galleries_images, :image_id, :unique => false
  end

  def self.down
    drop_table :galleries_images
  end
end
