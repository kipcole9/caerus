panel 'panels.contacts_index' do
  block :id => :contactSearch, :class => :search do
    search "Enter the name of the person you're looking for:", :replace => :contactCards
  end
  block :id => :contactCards do
    store render 'contacts'
  end
end