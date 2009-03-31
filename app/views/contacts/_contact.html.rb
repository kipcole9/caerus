# Render and object in business card layout
with_tag(:div, :class => "business_card") do
  store contact.given_name
  store contact.family_name
end