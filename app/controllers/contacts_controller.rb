class ContactsController < ApplicationController
  before_filter   :retrieve_contact, :only => [:update, :show]
  before_filter   :retrieve_contacts, :only => [:index]

  def show
    render :action => :edit
  end
  
  def create
    @contact = Person.new(params[:contact])
    @contact.save ? redirect_to(contact_path(@contact)) : render(:action => :edit)
  end

  def update
    @contact.update_attributes(params[:contact]) ?
      redirect_to(contact_path(@contact)) : render(:action => :edit)
  end
  
private
  def retrieve_contact
    @contact = current_account.contacts.find(params[:id])
  end
  
  def retrieve_contacts
    @contacts = current_account.contacts.all
  end
end
