class AddEmailToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :html_email, :text
    add_column :campaigns, :text_email, :text
  end

  def self.down
    remove_column :campaigns, :text_email
    remove_column :campaigns, :html_email
  end
end
