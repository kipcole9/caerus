class RecreateCampaign < ActiveRecord::Migration
  def self.up
    drop_table :campaigns
    create_table :campaigns do |t|
      t.belongs_to      :site    
      t.string          :name
      t.text            :description

      t.integer         :created_by
      t.integer         :updated_by
      t.timestamps
    end

  end

  def self.down
  end
end
