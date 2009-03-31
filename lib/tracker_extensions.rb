module TrackerExtensions

  def self.included(base)
    base.class_eval <<-EOF
      formats     :tracked_at => {:formatter => lambda {|t| (t.hour == 0 && t.min == 0 && t.sec == 0) ? t.to_date : t.to_s}}
      
      # => Date scoping
      named_scope   :between, lambda {|range| 
                      {:conditions => "tracked_at between '\#{range.first.to_s(:db)}' and '\#{range.last.to_s(:db)}'"}
                    }

      # => Campaign scoping
      named_scope   :campaign, lambda {|campaign|
                      {:conditions => {:campaign_name => campaign}}
                    }
                
      named_scope   :source, lambda {|source|
                      {:conditions => {:campaign_source => source}}
                    }         

      named_scope   :medium, lambda {|method|
                      {:conditions => {:campaign_medium => method}}
                    }
                    
      named_scope :by, lambda {|*args|
        # Args are passed as SELECT and GROUP clauses
        # with special attention paid to :day, :month, :year, :hour
        # configurations because the manipulate the #tracked_at formation
        #
        # Note that this also controls the grouping since we add each
        # argument to both the SELECT and GROUP.  This simplifies reporting
        # on either aggregate events (ie. 43 page views this month) versus
        # more fine-grained reporting.
        
        select = []
        group = []
        args.each do |a|
          case a
          when :day
            select << "date(tracked_at) as tracked_at"
            group << "date(tracked_at)"
          when :month
            select << "date_format(tracked_at, '%Y/%m/1') as tracked_at"
            group << "year(tracked_at), month(tracked_at)"
          when :year
            select << "date_format(tracked_at, '%Y/1/1') as tracked_at"
            group << "year(tracked_at)"
          when :hour
            select << "date_format(tracked_at, '%Y/%m/%d %k:00:00') as tracked_at"
            group << "day(tracked_at), hour(tracked_at)"
          else
            select << a.to_s
            group << a.to_s
          end
        end
        select << "count(*) as views"
        {:select => select.join(', '), :group => group.join(', ')}
      }

    EOF
  end

end