class RemoveDeadContactsColumns < ActiveRecord::Migration
  def self.up
    remove_column :contacts, :suffix
    remove_column :contacts, :prefix
    remove_column :contacts, :address_as
  end

  def self.down
  end
end
