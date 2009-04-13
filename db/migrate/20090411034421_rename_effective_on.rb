class RenameEffectiveOn < ActiveRecord::Migration
  def self.up
    rename_column :notes, :effective_on, :related_date
  end

  def self.down
    rename_column :notes, :related_date, :effective_on
  end
end
