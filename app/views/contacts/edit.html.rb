clear do
  column :width => 8 do
    include 'edit'
  end
  
  column :width => 4 do
    include "widgets/tweet"
  	include "prototypes/search"
  	include "calendars/this_month"
	end
end