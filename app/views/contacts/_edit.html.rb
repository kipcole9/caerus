# Create and edit a contact
panel 'panels.edit_contact' do
  block do
    store error_messages_for :contact
    caerus_form_for initialize_contact(@contact), :html => { :multipart => true }  do |contact|
      content_for :jstemplates, associated_template_for_new(contact, :emails)
      content_for :jstemplates, associated_template_for_new(contact, :websites)
      content_for :jstemplates, associated_template_for_new(contact, :phones)
            
      fieldset Contact.human_name.singularize, :id => :contact do
        section :position => :left do
          contact.hidden_field :account_id
          contact.text_field :given_name, :validate => :validations
          contact.text_field :family_name
          contact.text_field :salutation
        end
        section :position => :right do
          contact.text_field :role
          contact.text_field :organization
          if @contact.photo
            store image_tag @contact.photo.url(:thumb)
          end
          contact.file_field :photo, :size => 20
        end
      end
      
      fieldset Phone.human_name, :id => :phone, :buttons => :add do
        contact.fields_for :phones do |phone|
          render_form phone, 'phone'
        end
      end

      fieldset Email.human_name, :id => :email, :buttons => :add do
        contact.fields_for :emails do |email|
          render_form email, 'email'
        end
      end

      fieldset Website.human_name, :id => :website, :buttons => :add do
        contact.fields_for :websites do |website|
          render_form website, 'website'
        end
      end
      
      submit_combo :text => 'save'
    end
  end
end
