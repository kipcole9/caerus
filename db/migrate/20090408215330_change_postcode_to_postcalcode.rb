class ChangePostcodeToPostcalcode < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :postcode, :postalcode
  end

  def self.down
    rename_column :addresses, :postalcode, :postcode
  end
end
