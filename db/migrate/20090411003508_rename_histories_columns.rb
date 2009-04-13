class RenameHistoriesColumns < ActiveRecord::Migration
  def self.up
    rename_column :histories, :history_id, :historical_id
    rename_column :histories, :history_type, :historical_type
  end

  def self.down
    rename_column :histories, :historical_id, :history_id
    rename_column :histories, :historical_type, :history_type
  end
end
