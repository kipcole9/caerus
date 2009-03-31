class Contact < ActiveRecord::Base
  belongs_to    :account
  has_many      :websites
  has_many      :emails
  has_many      :instant_messengers
  has_many      :phones
  has_many      :addresses
  has_many      :affiliates
  
  has_attached_file :photo, :styles => { :thumb=> "100x100#", :small  => "150x150>", :card => "50x50#" },
                    :convert_options => { :all => "-unsharp 0.3x0.3+3+0" }
   
  accepts_nested_attributes_for :websites,            :allow_destroy => true, :reject_if => proc { |attributes| attributes['address'].blank? }
  accepts_nested_attributes_for :emails,              :allow_destroy => true, :reject_if => proc { |attributes| attributes['address'].blank? }
  accepts_nested_attributes_for :instant_messengers,  :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :phones,              :allow_destroy => true, :reject_if => proc { |attributes| attributes['address'].blank? }
  accepts_nested_attributes_for :addresses,           :allow_destroy => true
  accepts_nested_attributes_for :affiliates,          :allow_destroy => true
end
