class AddTimezoneToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :timezone, :string, :limit => 50
  end

  def self.down
    remove_column :users, :timezone
  end
end
