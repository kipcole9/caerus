class AddPreviousSessionToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :previous_session, :datetime
  end

  def self.down
    remove_column :tracks, :previous_session
  end
end
