class AddPreferredFields < ActiveRecord::Migration
  def self.up
    add_column :websites, :preferred, :boolean, :default => 0
    add_column :addresses, :preferred, :boolean, :default => 0
    add_column :instant_messengers, :preferred, :boolean, :default => 0
    add_column :phones, :preferred, :boolean, :default => 0
  end

  def self.down
    remove_column :websites, :preferred
    remove_column :addresses, :preferred
    remove_column :instant_messengers, :preferred
    remove_column :phones, :preferred
  end
end
