module ContactsHelper
  def initialize_contact(contact)
    @contact = current_account.contacts.build unless contact
    returning(@contact) do |c|
      c.emails.build if c.emails.empty?
      c.websites.build if c.websites.empty?
      c.phones.build if c.phones.empty?
    end
  end
  
end
