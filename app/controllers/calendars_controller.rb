class CalendarsController < ApplicationController

# TODO:
# respond_to to ensure the right stuff goes back
# for json, html, xhr, etc etc etc

  def update
    respond_to do |format|
      format.html do
        current_account.calendar = new_calendar
        current_account.save!
        @calendar = new_calendar.calendar
        render :partial => "calendars/this_quarter"
      end
    end
  end
  
private
  # Take calendar parameters and convert to a real calendar
  # Then put that calendar in the parameters has for the account
  # so that it can be mass-assigned.
  def new_calendar
    return calendar unless params["calendar"]
    CalendarProxy.new(params["calendar_type"], params["calendar"])
  end
  
end