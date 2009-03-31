module AccountsHelper
  def select_calendar_type(a)
    options = [[tt('calendar.standard_calendar'), "gregorian"], [tt('calendar.thirteen_week'), "thirteen_week"]]
    @template.select_tag("calendar_type", options_for_select(options, a.calendar_type), :name => "calendar_type")
  end
  
  def select_month(a)
    options = I18n.t('date.month_names').collect{|i| [i, i.downcase] unless i.nil?}.compact
    @template.select_tag("account_calendar_month", options_for_select(options, a.calendar_month), :name => "calendar[calendar_month]")    
  end
  
  def select_day(a)
    options = I18n.t('date.day_names').collect{|i| [i, i.downcase] unless i.nil?}.compact
    @template.select_tag("account_calendar_day_of_week", options_for_select(options, a.calendar_day_of_week), :name => "calendar[calendar_day_of_week]")    
  end
  
  def select_begins_ends(a)
    options = [[tt('calendar.begins'), "begins"], [tt('calendar.ends'), "ends"]]
    @template.select_tag("account_calendar_begins_or_ends", options_for_select(options, a.calendar_begins_or_ends), :name => "calendar[calendar_begins_or_ends]")    
  end
  
  def select_first_last(a)
    options = [[tt('calendar.first'), "first"], [tt('calendar.last'), "last"]]
    @template.select_tag("account_calendar_first_or_last", options_for_select(options, a.calendar_first_or_last), :name => "calendar[calendar_first_or_last]")    
  end
  
  def select_week_starts_in(a)
    options = [[tt('calendar.first_full_week'), "full"],[tt('calendar.week_of_first_day'), "first"]]
    @template.select_tag("account_calendar_first_or_full", options_for_select(options, a.calendar_first_or_full), :name => "calendar[calendar_first_or_full]")
  end
  
  def select_quarter_type(a)
    options = [["4-4-5", "445"],["4-5-4", "454"],["5-4-4", "544"]]
    @template.select_tag("account_calendar_quarter_type", options_for_select(options, a.calendar_quarter_type), :name => "calendar[calendar_quarter_type]")
  end
  
  # need to add "use_ending_year" checkbox too
end
