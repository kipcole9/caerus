class AddContactToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :contact_id, :integer
    add_column :organizations, :account_id, :integer
  end

  def self.down
    remove_column :organizations, :account_id
    remove_column :organizations, :contact_id
  end
end
