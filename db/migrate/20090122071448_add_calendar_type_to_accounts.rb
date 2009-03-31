class AddCalendarTypeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :calendar_type,             :string,  :limit => 20, :default => "gregorian"
    add_column :accounts, :calendar_month,            :string,  :limit => 10, :default => "january"
    add_column :accounts, :calendar_begins_or_ends,   :string,  :limit => 10, :default => "begins"
    add_column :accounts, :calendar_first_or_last,    :string,  :limit => 5,  :default => "first"
    add_column :accounts, :calendar_day_of_week,      :string,  :limit => 10, :default => "sunday"
    add_column :accounts, :calendar_first_or_full,    :string,  :limit => 10, :default => "first" 
    add_column :accounts, :calendar_use_ending_year,  :boolean,               :default => false 
    add_column :accounts, :calendar_quarter_type,     :string,  :limit => 3,  :default => "445" 
  end

  def self.down
    remove_column :accounts, :calendar_type
    remove_column :accounts, :calendar_month            
    remove_column :accounts, :calendar_begins_or_ends   
    remove_column :accounts, :calendar_first_or_last    
    remove_column :accounts, :calendar_day_of_week      
    remove_column :accounts, :calendar_first_or_full    
    remove_column :accounts, :calendar_use_ending_year  
    remove_column :accounts, :calendar_quarter_type     
  end
end
