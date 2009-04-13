class DropTableLogs < ActiveRecord::Migration
  def self.up
    drop_table :logs
  end

  def self.down
  end
end
