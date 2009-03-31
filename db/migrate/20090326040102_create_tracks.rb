class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.belongs_to      :account
      t.string          :account_code, :limit => 20
      t.string          :visitor, :limit => 20
      t.string          :session, :limit => 20
      t.string          :page_title
      t.string          :screen_size, :limit => 10
      t.string          :color_depth, :limit => 5
      t.string          :language, :limit => 10
      t.string          :charset, :limit => 10
      t.string          :flash_version, :limit => 10
      t.string          :unique_request, :limit => 20
      t.string          :campaign_name
      t.string          :campaign_source
      t.string          :campaign_medium
      t.string          :campaign_content
      t.string          :url
      t.string          :ip_address, :limit => 20
      t.string          :referrer
      t.string          :user_agent
      
      # Derived values- summarising or decoding raw data
      t.string          :browser
      t.string          :browser_version
      t.string          :country, :limit => 20
      t.string          :region, :limit => 20
      t.string          :locality, :limit => 20
      t.float           :latitude
      t.float           :longitude
      
      # Timestamps
      t.datetime        :tracked_at
      t.datetime        :geocoded_at
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
