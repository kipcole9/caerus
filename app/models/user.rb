require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  VALID_USER_NAME            = /\A[^[:cntrl:]\\<>\/&]+\z/ 
  belongs_to                :account
  belongs_to                :contact
  has_many                  :team_members
  has_many                  :teams, :through => :team_members
  has_many                  :group_members
  has_many                  :users, :through => :group_members
  
  has_many                  :histories, :class_name => "History", :foreign_key => :created_by

  validates_presence_of     :login
  validates_length_of       :login,         :within => 3..40
  validates_format_of       :login,         :with => Authentication.login_regex
  validates_uniqueness_of   :login

  validates_presence_of     :first_name
  validates_format_of       :first_name,    :with => VALID_USER_NAME
  validates_length_of       :first_name,    :maximum => 100
  
  validates_presence_of     :last_name
  validates_format_of       :last_name,     :with => VALID_USER_NAME
  validates_length_of       :last_name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,         :within => 6..100 #r@a.wk
  validates_format_of       :email,         :with => Authentication.email_regex
  validates_uniqueness_of   :email
  
  attr_accessible :login, :email, :first_name, :last_name, :locale, :timezone

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(account, login, password)
    return nil if login.blank? || password.blank?
    u = account.users.find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def is_account_admin?
    account_admin?
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def name
    [self.first_name, self.last_name].compact.join(' ')
  end
  
protected
    
private

end
