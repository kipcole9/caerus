class ChangeHistoryColumn < ActiveRecord::Migration
  def self.up
    rename_column :histories, :changes, :updates
  end

  def self.down
    rename_column :histories, :updates, :changes
  end
end
