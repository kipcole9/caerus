class AddSubjectToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :subject, :string
    add_column :campaigns, :reply_to, :string
  end

  def self.down
    remove_column :campaigns, :reply_to
    remove_column :campaigns, :subject
  end
end
