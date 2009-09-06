class AddActivationHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_hash, :string
  end

  def self.down
    remove_column :users, :activation_hash
  end
end
