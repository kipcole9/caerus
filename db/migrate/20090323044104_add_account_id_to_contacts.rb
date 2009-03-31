class AddAccountIdToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :account_id, :integer
  end

  def self.down
    remove_column :contacts, :account_id
  end
end
