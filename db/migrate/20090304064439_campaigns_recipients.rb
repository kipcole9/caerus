class CampaignsRecipients < ActiveRecord::Migration
  def self.up
    create_table :mailings do |t|
      t.belongs_to      :campaign
      t.belongs_to      :recipient
      t.datetime        :sent_at
      t.string          :status
    end
  end

  def self.down
    drop_table :mailings
  end
end
