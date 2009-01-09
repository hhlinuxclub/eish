class AddIsAddressToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :is_address, :boolean, :default => false
  end

  def self.down
    remove_column :events, :is_address
  end
end
