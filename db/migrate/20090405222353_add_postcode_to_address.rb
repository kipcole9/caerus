class AddPostcodeToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :postcode, :string, :limit => 10
    rename_column :addresses, :city, :locality
    remove_column :addresses, :street_2
    rename_column :addresses, :street_1, :street
  end

  def self.down
    remove_column :addresses, :postcode
    rename_column :addresses, :locality, :city
    add_column :addresses, :street_2, :string
    rename_column :addresses, :street, :street_1
  end
end
