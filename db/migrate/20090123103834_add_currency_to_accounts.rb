class AddCurrencyToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :currency, :string, :limit => 3
  end

  def self.down
    remove_column :accounts, :currency
  end
end
