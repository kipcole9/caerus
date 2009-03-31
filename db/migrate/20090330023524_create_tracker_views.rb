class CreateTrackerViews < ActiveRecord::Migration
  def self.up

    execute "create view page_views as " +
              "select id, site_id, count(*) as views, url, country, locality, ip_address, tracked_at from tracks where " +
              "outbound = 0 AND session IS NOT NULL and url IS NOT NULL " +
      		    "group by url, tracked_at;"     
  
    execute "create view page_views_per_visit as " +
              "select site_id, count(*) as views, visitor, session, tracked_at from tracks " +    
              "where outbound = 0 AND session IS NOT NULL " +
              "group by visitor, session;"

    execute  "create view visitors as " +
                "select site_id, count(*) as count, visitor, tracked_at from tracks " +    
                "group by visitor;"
                
    execute "create view visits as " +         
              "select site_id, count(visit) as visits, visitor, session, tracked_at from tracks " +         
              "where view = 1 " + 
              "group by site_id, visitor, session"
                              
    execute "create view new_visitors as " +  
              "select site_id, visitor, tracked_at from tracks " +        
              "where visit = 1 AND view = 1 AND session IS NOT NULL;"
              
    execute "create view return_visitors as " +
              "select site_id, visitor, tracked_at from tracks " +
              "where visit > 1 AND view = 1 AND session IS NOT NULL;"

    execute "create view repeat_visitors as " +
              "select site_id, count(*) as count, visitor, tracked_at from tracks " +
              "where view = 1 AND session IS NOT NULL " +      
              "group by visitor " +
              "having count(*) > 1;"
    
    execute "create view entry_pages as " +     
              "select site_id, url, tracked_at from tracks " +
              "where view = 1 AND url IS NOT NULL"   
              
    execute "create view landing_pages as " +
              "select site_id, url, tracked_at from tracks " +
              "where view = 1 AND url IS NOT NULL AND campaign_name IS NOT NULL;"     
              
    execute "create view visit_duration as " +
              "select site_id, TIMESTAMPDIFF(MINUTE, min(tracked_at), max(tracked_at)) as duration, visitor, session, tracked_at from tracks " +
              "group by visitor, session"
              
    execute "create view clicks_through as " +
              "select site_id, visitor, session, url, tracked_at from tracks " +    
              "where outbound = 1;"
              
    execute "create view bounces as " +         
              "select site_id, url, visitor, session, tracked_at from tracks " +         
              "group by visitor, session " + 
              "having count(*) = 1;"
              
    execute "create view opened_emails as " +
              "select site_id, count(*) as count, campaign_name, ip_address, country, locality, tracked_at from tracks " + 
              "where campaign_source = 'open' AND campaign_medium = 'email' " +
              "group by ip_address, campaign_name;"
  
    execute "create view clicked_emails as " +
              "select site_id, count(*) as count, campaign_name, ip_address, country, locality, tracked_at from tracks " +
              "where campaign_source = 'landing' AND campaign_medium = 'email' " +
              "group by ip_address, campaign_name;"

  end
  
  

  def self.down
    execute 'drop view page_views'
    execute 'drop view page_views_per_visit'
    execute 'drop view visitors'
    execute 'drop view visits'
    execute 'drop view new_visitors'
    execute 'drop view return_visitors'
    execute 'drop view repeat_visitors'
    execute 'drop view entry_pages'
    execute 'drop view landing_pages'
    execute 'drop view visit_duration'
    execute 'drop view clicks_through'
    execute 'drop view bounces'
    execute 'drop view opened_emails'
    execute 'drop view clicked_emails'
  end
end
