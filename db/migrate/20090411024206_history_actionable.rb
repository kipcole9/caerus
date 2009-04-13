class HistoryActionable < ActiveRecord::Migration
  def self.up
    add_column :histories, :actionable_type, :string, :limit => 20
    add_column :histories, :actionable_id, :integer
    remove_column :histories, :refers_to
  end

  def self.down
    create_column :historis, :refers_to, :string
    remove_column :histories, :actionable_type
    remove_column :histories, :actionable_id
  end
end
