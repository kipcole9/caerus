class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      # Details for a person
      t.string      :given_name
      t.string      :family_name
      t.string      :saluation,     :limit => 30
      t.string      :prefix,        :limit => 20
      t.string      :suffix,        :limit => 20
      t.string      :nickname,      :limit => 20
      t.string      :greeting,      :limit => 20
      t.string      :address_as,    :limit => 50
      
      # Details for an organization
      t.string      :name,          :limit => 100
      t.string      :division,      :limit => 100
      t.string      :location,      :limit => 100
      
      # For both
      t.string      :type,        :limit => 10
      t.string      :locale,        :limit => 50
      t.string      :timezone,      :limit => 50
      t.timestamps
    end
    add_index(:contacts, :family_name)
    add_index(:contacts, :given_name)
    add_index(:contacts, :name)
    
    create_table :emails do |t|
      t.belongs_to  :contact
      t.string      :address
      t.string      :type, :limit => 10
      t.boolean     :preferred, :default => 0
    end
    add_index(:emails, :contact_id)
    
    create_table :phones do |t|
      t.belongs_to  :contact
      t.string      :type, :limit => 10
      t.string      :number, :limit => 20
    end
    add_index(:phones, :contact_id)
    
    create_table :websites do |t|
      t.belongs_to  :contact
      t.string      :type, :limit => 10
      t.string      :url
    end
    add_index(:websites, :contact_id)
    
    create_table :instant_messengers do |t|
      t.belongs_to  :contact
      t.string      :type, :limit => 10
      t.string      :address
    end
    add_index(:instant_messengers, :contact_id)
    
    create_table :addresses do |t|
      t.belongs_to  :contact
      t.string      :street_1
      t.string      :street_2
      t.string      :city
      t.string      :country
    end
    add_index(:addresses, :contact_id)
    
    create_table :affiliations do |t|
      t.belongs_to  :contact
      t.string      :type, :limit => 10
      t.belongs_to  :affiliate
    end
    add_index(:affiliations, :contact_id)
    add_index(:affiliations, :affiliate_id)
  end

  def self.down
    drop_table :contacts
  end
end
