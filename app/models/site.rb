class Site < ActiveRecord::Base
  has_many      :tracks
  has_many      :page_views
  has_many      :visitors
  has_many      :visits
  has_many      :bounces
  has_many      :opened_emails
  has_many      :clicked_emails
  has_many      :visit_durations
  has_many      :new_visitors
  has_many      :return_visitors
  has_many      :repeat_visitors
  has_many      :landing_pages
  has_many      :entry_pages
  has_many      :exit_pages
  has_many      :campaigns
end
