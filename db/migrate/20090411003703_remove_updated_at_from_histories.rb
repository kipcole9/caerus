class RemoveUpdatedAtFromHistories < ActiveRecord::Migration
  def self.up
    remove_column :histories, :updated_at
  end

  def self.down
    add_column :histories, :updated_at, :datetime
  end
end
