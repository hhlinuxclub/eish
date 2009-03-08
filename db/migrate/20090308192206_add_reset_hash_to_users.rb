class AddResetHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_hash, :string, :default => nil
    add_column :users, :reset_hash_expires, :datetime, :default => nil
  end

  def self.down
    remove_column :users, :reset_hash
    remove_column :users, :reset_hash_expires
  end
end
