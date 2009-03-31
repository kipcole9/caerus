class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.belongs_to    :account
      t.string        :tracker
      t.string        :base_url
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
