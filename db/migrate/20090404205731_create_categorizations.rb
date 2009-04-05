class CreateCategorizations < ActiveRecord::Migration
  def self.up
    create_table :categorizations, :id => false do |t|
      t.integer :article_id
      t.integer :category_id
    end
  end

  def self.down
    drop_table :categorizations
  end
end
