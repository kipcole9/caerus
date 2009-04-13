class Contact < ActiveRecord::Base
  belongs_to    :account
  belongs_to    :created_by,  :class_name => "User", :foreign_key => :created_by
  belongs_to    :updated_by,  :class_name => "User", :foreign_key => :updated_by
  has_many      :actions,     :as => :actionable, :class_name => "History"
  has_many      :updates,     :as => :historical, :class_name => "History"
  has_many      :notes,       :as => :notable
  has_many      :affiliates  
  has_many      :websites,            :autosave => true, :validate => true, :dependent => :destroy
  has_many      :emails,              :autosave => true, :validate => true, :dependent => :destroy
  has_many      :instant_messengers,  :autosave => true, :validate => true, :dependent => :destroy
  has_many      :phones,              :autosave => true, :validate => true, :dependent => :destroy
  has_many      :addresses,           :autosave => true, :validate => true, :dependent => :destroy do
    # How to decide if an address exists?
    # Street address is almost useless since its format
    # varies widely.  We'll use city, region, country
    # and kind as the "close enough" test.
    def find_by_vcard(card_address)
      conditions = {}
      ["locality", "region", "country", "postalcode"].each do |a|
        conditions[a] = card_address.send(a) unless card_address.send(a).blank?
      end
      conditions["kind"] = card_address.location.first
      find(:first, :conditions => sanitize_sql_for_conditions(conditions))
    end
  end
  
  has_attached_file :photo, :styles => { :thumb=> "100x100#", :small  => "150x150>", :avatar => "50x50#" },
                    :convert_options => { :all => "-unsharp 0.3x0.3+3+0" }
   
  accepts_nested_attributes_for :websites,            :allow_destroy => true, :reject_if => proc { |attributes| attributes['url'].blank? }
  accepts_nested_attributes_for :emails,              :allow_destroy => true, :reject_if => proc { |attributes| attributes['address'].blank? }
  accepts_nested_attributes_for :instant_messengers,  :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :phones,              :allow_destroy => true, :reject_if => proc { |attributes| attributes['number'].blank? }
  accepts_nested_attributes_for :addresses,           :allow_destroy => true, :reject_if => proc { |attributes| self.all_blank?(attributes) }
  accepts_nested_attributes_for :affiliates,          :allow_destroy => true, :reject_if => proc { |attributes| attributes['address'].blank? }

  def full_name
    [self.given_name, self.family_name].join(' ')
  end
  
  def full_name_and_title
    [self.full_name, self.role, self.organization].join(', ')
  end
  
  def self.import(vcard)
    self.import_vcards()
  end
  
  def self.import_vcards(card_file)
    @cards = Vpim::Vcard.decode(File.open(card_file).read)
    @cards.each {|card| self.import_vcard(card) }
    @cards.length
  end
  
  def self.import_vcard(card)
    contact = find_or_create_by_vcard(card)
    contact.import_vcard(card)
  end
  
  def self.find_or_create_by_vcard(card)
    emails = card.emails.dup.map(&:to_s).uniq
    contact = find_by_emails(emails) || find_by_names_and_company(card) || self.new
  end
  
  def self.find_by_emails(emails)
    return nil unless emails
    contact_email_addresses = Email.find(:all, :select => "DISTINCT contact_id", :conditions => {:address => emails})
    return nil if contact_email_addresses.empty?
    
    if contact_email_addresses.length > 1
      puts emails.join(', ')
      raise "Don't know how to import a card that spans multiple existing contact email addresses"
    end
    contact_email_addresses.first.contact
  end
    
  def self.find_by_names_and_company(card)
    conditions = {}
    conditions[:given_name]   = card.name.given if card.name.given
    conditions[:family_name]  = card.name.family if card.name.family
    conditions[:role]         = card.title if card.title
    conditions[:organization] = card.org.first if card.org && card.org.first
    contact = find(:first, :conditions => sanitize_sql_for_conditions(conditions))
  end
  
  def import_vcard(card)
    self.given_name = card.name.given unless card.name.given.blank?
    self.family_name = card.name.family unless card.name.family.blank?
    self.role = card.title unless card.title.blank?
    self.organization = card.org.join("\n").strip if card.org

    Contact.transaction do
      puts self.errors.inspect unless self.save
      import_emails(card.emails)
      import_websites(card.urls)
      import_addresses(card.addresses)
      import_telephones(card.telephones)
    end
  end
  
  def refers_to
    self
  end

private
  def import_emails(emails)
    emails.each do |card_email|
      email_address = card_email.to_s
      email = self.emails.find_by_address(email_address) || self.emails.build
      email.kind = card_email.location.first
      email.address = email_address
      email.preferred = card_email.preferred
      puts email.errors.inspect unless email.save
    end
  end
  
  def import_websites(websites)
    websites.each do |card_website|
      website_address = card_website.uri.gsub('\\','')
      website = self.websites.find_by_url(website_address) || self.websites.build
      website.url = website_address
      puts website.errors.inspect unless website.save
    end
  end
  
  def import_telephones(phones)
    phones.each do |card_phone|
      number = card_phone.to_s
      phone = self.phones.find_by_number(number) || self.phones.build
      phone.kind = card_phone.location.first
      phone.number = number
      phone.preferred = card_phone.preferred
      puts phone.errors.inspect unless phone.save
    end
  end
  
  def import_addresses(addresses)
    addresses.each do |card_address|
      address = self.addresses.find_by_vcard(card_address) || self.addresses.build
      address.kind = card_address.location.first
      address.street = card_address.street
      address.locality = card_address.locality
      address.region = card_address.region
      address.country = card_address.country
      address.postalcode = card_address.postalcode
      address.preferred = card_address.preferred
      puts address.errors.inspect unless address.save
    end
  end
      
  def self.all_blank?(attributes)
    attributes.each do |a|
      return false unless a.blank?
    end
    return true
  end
end
