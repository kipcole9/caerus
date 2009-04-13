class Organization < ActiveRecord::Base
  
  # Used in autocomplete
  named_scope   :name_like, lambda {|name| {:conditions => "name like '%#{name}%'"}}
  
end
