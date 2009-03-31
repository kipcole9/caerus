class AddCountToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :count, :integer
    add_column :tracks, :duration, :time
    add_column :tracks, :outbound, :boolean, :default => 0
  end

  def self.down
    remove_column :tracks, :count
    remove_column :tracks, :duration
    remove_column :tracks, :outbound
  end
end
