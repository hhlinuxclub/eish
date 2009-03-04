class AddContactableToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :contactable, :boolean, :default => false
  end

  def self.down
    remove_column :users, :contactable
  end
end
