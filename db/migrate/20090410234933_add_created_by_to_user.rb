class AddCreatedByToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :created_by, :integer
    add_column :users, :updated_by, :integer
  end

  def self.down
    remove_column :users, :updated_by
    remove_column :users, :created_by
  end
end
