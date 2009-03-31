class AddColumnsToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :visit, :integer
    add_column :tracks, :view, :integer
  end

  def self.down
    remove_column :tracks, :visit
    remove_column :tracks, :view
  end
end
