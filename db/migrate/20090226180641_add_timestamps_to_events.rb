class AddTimestampsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :created_at, :datetime
    add_column :events, :updated_at, :datetime
  end

  def self.down
    remove_column :events, :created_at
    remove_column :events, :updated_at
  end
end
