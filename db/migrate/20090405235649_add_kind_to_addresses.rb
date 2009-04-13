class AddKindToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :kind, :string, :limit => 10
  end

  def self.down
    remove_column :addresses, :kind
  end
end
