clear do
  column :width => 8 do
    include 'emails_opened'
    include 'emails_clicked'
  end
  
  column :width => 4 do
    include "emails_summary"
	end
end