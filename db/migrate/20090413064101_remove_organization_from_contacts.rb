class RemoveOrganizationFromContacts < ActiveRecord::Migration
  def self.up
    remove_column :contacts, :organization
  end

  def self.down
    add_column :contacts, :organization, :string
  end
end
