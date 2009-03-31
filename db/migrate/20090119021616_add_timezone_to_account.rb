class AddTimezoneToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :timezone, :string, :limit => 40
    add_column :accounts, :company_name, :string
    add_column :users, :account_admin, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :timezone
    remove_column :users, :account_admin
    remove_column :accounts, :company_name
  end
end
