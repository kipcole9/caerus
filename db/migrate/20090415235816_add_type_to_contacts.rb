class AddTypeToContacts < ActiveRecord::Migration
  def self.up
    #add_column :contacts, :type, :string
    execute "update contacts set type='Person'"
  end

  def self.down
    remove_column :contacts, :type
  end
end
