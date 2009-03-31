class CreateCampaign < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string          :name
    end
    
    create_table :campaigns do |t|
      t.string          :name
      t.belongs_to      :account
      t.datetime        :sent_at
      t.timestamps
    end
    
    create_table :clicks do |t|
      t.belongs_to      :campaign
      t.belongs_to      :responder
      t.string          :browser
      t.string          :ip_address
      t.string          :location
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
    drop_table :campaigns
    drop_table :clicks
  end
end
