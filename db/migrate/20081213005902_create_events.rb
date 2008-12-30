class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :location
      t.text :description
      t.integer :user_id
    end
  end

  def self.down
    drop_table :events
  end
end
