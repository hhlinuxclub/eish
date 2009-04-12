class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :description
      t.string :upload_file_name
      t.string :upload_content_type
      t.integer :upload_file_size
      t.integer :user_id
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
