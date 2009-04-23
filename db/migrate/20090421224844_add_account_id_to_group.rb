class AddAccountIdToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :account_id, :integer
  end

  def self.down
    remove_column :groups, :account_id
  end
end
