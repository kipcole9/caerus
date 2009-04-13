class AddCreatedByAndTimestamps < ActiveRecord::Migration
  def self.up
    [:websites, :phones, :addresses, :emails].each do |t|
      add_column t, :created_at, :datetime
      add_column t, :updated_at, :datetime
    end
  end

  def self.down
    [:websites, :phones, :addresses, :emails].each do |t|
      remove_column t, :created_at
      remove_column t, :updated_at
    end
  end
end
