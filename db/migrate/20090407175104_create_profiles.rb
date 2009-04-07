class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :url
      t.text :about
      t.string :degree_programme
      t.integer :graduation_year
      t.string :distribution
      t.string :desktop_environment
      t.string :text_editor
      t.string :programming_language
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
