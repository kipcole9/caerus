class ChangeAccountCodeOnTracks < ActiveRecord::Migration
  def self.up
    rename_column :tracks, :account_id, :site_id
    rename_column :tracks, :account_code, :site_code
  end

  def self.down
  end
end
