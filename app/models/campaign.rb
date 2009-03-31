class Campaign < ActiveRecord::Base
  has_many    :tracks
  belongs_to  :site
    
  
end
