class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.boolean :can_create, :default => false
      t.boolean :can_update, :default => false
      t.boolean :can_delete, :default => false
      t.boolean :can_publish, :default => false
      t.boolean :can_administer, :default => false
    end
  end

  def self.down
    drop_table :roles
  end
end
