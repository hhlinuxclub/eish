class AddPublishingTimestamps < ActiveRecord::Migration
  def self.up
    if SEARCH_ENABLED
      raise("This migration MUST be run with SEARCH_ENABLED=false in the settings initializer")
    end

    add_column :news, :published_at, :datetime
    add_column :articles, :published_at, :datetime
    add_column :events, :published_at, :datetime
    add_column :galleries, :published_at, :datetime

    [News, Article, Event, Gallery].each do |type|
      say "Updating " + type.model_name.pluralize
      type.find_all_by_published(true).each do |item|
        say "id: " + item.id.to_s, true
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
