class AdjustContacts < ActiveRecord::Migration
  def self.up
    remove_column :contacts, :division
    remove_column :contacts, :location
    rename_column :contacts, :saluation, :salutation
    add_column :contacts, :role, :string
    add_column :contacts, :organization, :string
  end

  def self.down
  end
end
