class AddRememberMeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_token, :string
    add_column :users, :remember_token_expires, :datetime
  end

  def self.down
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires
  end
end
