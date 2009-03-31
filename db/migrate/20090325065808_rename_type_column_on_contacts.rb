class RenameTypeColumnOnContacts < ActiveRecord::Migration
  def self.up
    remove_column :contacts, :type
    rename_column :emails, :type, :kind
    rename_column :websites, :type, :kind
    rename_column :phones, :type, :kind
  end

  def self.down
    add_column :contacts, :type, :string, :limit => 20
    rename_column :emails, :kind, :type
    rename_column :websites, :kind, :type
    rename_column :phones, :kind, :type 
  end
end
