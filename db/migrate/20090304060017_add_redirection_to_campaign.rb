class AddRedirectionToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :redirection, :string
  end

  def self.down
    remove_column :campaigns, :redirection
  end
end
