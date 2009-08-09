class AddPublishingTimestamps < ActiveRecord::Migration
  def self.up
    add_column :news, :published_at, :datetime
    add_column :articles, :published_at, :datetime
    add_column :events, :published_at, :datetime
    add_column :galleries, :published_at, :datetime
    
    [News, Article, Event, Gallery].each do |type|
      type.find_all_by_published(true).each do |item|
        item.published_at = item.created_at
        item.save(false)
      end
    end
  end

  def self.down
    remove_column :galleries, :published_at
    remove_column :events, :published_at
    remove_column :articles, :published_at
    remove_column :news, :published_at
  end
end
