class MoveOrganizationToSti < ActiveRecord::Migration
  def self.up
    drop_table :organizations
    add_column :contacts, :employees, :integer
    add_column :contacts, :revenue, :integer
    remove_column :contacts, :greeting
  end

  def self.down
  end
end
