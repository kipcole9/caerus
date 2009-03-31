class AddProfileToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :profile, :string
    add_column :contacts, :photo, :string
  end

  def self.down
    remove_column :contacts, :photo
    remove_column :contacts, :profile
  end
end
