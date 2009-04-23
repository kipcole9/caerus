class AddGenderToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :gender, :string, :limit => 10, :default => "unknown"
    add_column :contacts, :role_function, :string, :limit => 50
    add_column :contacts, :role_level, :string, :limit => 50
    add_column :contacts, :name_order, :string, :limit => 2
  end

  def self.down
    remove_column :contacts, :gender
    remove_column :contacts, :role_function
    remove_column :contacts, :role_level
    remove_column :contacts, :name_order
  end
end
