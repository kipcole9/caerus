class ChangeStateToRegion < ActiveRecord::Migration
  def self.up
    rename_column :addresses,:state, :region
  end

  def self.down
    rename_column :addresses, :region, :state
  end
end
