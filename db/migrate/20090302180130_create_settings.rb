class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :option
      t.text :value, :default => ""
      t.timestamps
    end
    
    add_index :settings, :option, :unique => true
  end

  def self.down
    drop_table :settings
  end
end
