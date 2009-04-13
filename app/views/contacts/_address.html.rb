with_tag(:div, :class => :address) do
 clear :id => "street" do
    f.hidden_field :id
    f.text_area :street, :size => "30x3", :focus => true, :label_class => :street
    f.select :kind, I18n.translate('address_types'), :no_label => true
    f.buttons :delete
  end
  f.text_field :locality
  f.text_field :region
  f.text_field :country, :autocomplete => true
  f.text_field :postalcode, :size => 20
end