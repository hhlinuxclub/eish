class CreateXapitChanges < ActiveRecord::Migration
  def self.up
    create_table "xapit_changes" do |t|
      t.string "target_class"
      t.integer "target_id"
      t.string "operation"
    end
  end
  
  def self.down
    drop_table "xapit_changes"
  end
end
