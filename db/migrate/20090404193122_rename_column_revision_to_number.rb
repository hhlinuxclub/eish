class RenameColumnRevisionToNumber < ActiveRecord::Migration
  def self.up
    rename_column :revisions, :revision, :number
  end

  def self.down
  end
end
