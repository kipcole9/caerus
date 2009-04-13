class UpdateNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :note, :text
    add_column :notes, :notable_type, :string, :limit => 20
    add_column :notes, :notable_id, :integer
    add_column :notes, :updated_by, :integer
    add_column :notes, :created_by, :integer
    add_column :notes, :effective_on, :date
  end

  def self.down
    remove_column :notes, :note
    remove_column :notes, :notable_type
    remove_column :notes, :notable_id
    remove_column :notes, :updated_by
    remove_column :notes, :created_by
    remove_column :notes, :effective_on
  end
end
