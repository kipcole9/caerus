with_tag(:div, :class => :inline) do
  f.hidden_field :id
  f.text_field :address, :validate => :validations, :focus => true
  f.check_box :preferred, :class => 'preferred', :no_label => true, :title => tt('preferred')
  f.select :kind, I18n.translate('email_types'), :no_label => true
  f.buttons :delete
end