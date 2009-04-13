class AddCreatedByToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :created_by, :integer
    add_column :contacts, :updated_by, :integer
  end

  def self.down
    remove_column :contacts, :updated_by
    remove_column :contacts, :created_by
  end
end
