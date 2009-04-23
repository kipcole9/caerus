class AddContactIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :contact_id, :integer
  end

  def self.down
    remove_column :users, :contact_id
  end
end
