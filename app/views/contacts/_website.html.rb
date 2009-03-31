with_tag(:div, :class => :inline) do
  f.hidden_field :id
  f.text_field :url
  f.select :kind, I18n.translate('website_types'), :no_label => true
  f.buttons :delete
end