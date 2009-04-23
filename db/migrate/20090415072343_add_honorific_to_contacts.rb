class AddHonorificToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :honorific_prefix, :string, :limit => 50
    add_column :contacts, :honorific_suffix, :string, :limit => 50
  end

  def self.down
    remove_column :contacts, :honorific_suffix
    remove_column :contacts, :honorific_prefix
  end
end
