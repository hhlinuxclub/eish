class AddAddressToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :address, :string
    remove_column :events, :is_address
  end

  def self.down
    remove_column :events, :address
    add_column :events, :is_address, :boolean, :default => false
  end
end
