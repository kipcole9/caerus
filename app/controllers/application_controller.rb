# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper            :all # include all helpers, all the time
  helper_method     :current_account, :calendar
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  before_filter     :subdomains_allowed?
  before_filter     :account_exists?
  before_filter     :subdomain_logged_in?
  before_filter     :set_locale
  before_filter     :set_timezone
  before_filter     :set_calendar

  layout            'application', :except => [:rss, :xml, :json, :atom, :vcf, :xls, :csv, :pdf]

  def subdomains_allowed?
    # Overwritten in descendant classes if required.
  end
  
  def account_exists?
    Account.find_by_name!(account_subdomain) if request_has_subdomains?
  end
    
  def subdomain_logged_in?
    if request_has_subdomains? && !logged_in? && !login_controller?
      store_location
      flash[:notice] = 'must_login'
      redirect_to login_path 
    end
  end

  # Prededence:
  # => :lang parameter, if it can be matched with an available locale
  # => locale in the user profile, if they're logged in
  # => priority locale from the Accept-Language header of the request
  # => The default site locale
  def set_locale
    language = params.delete(:lang)
    locale = I18n.available_locales & [language] if language
    locale = current_user.locale if logged_in? && !locale
    locale ||= request.preferred_language_from(I18n.available_locales)
    I18n.locale = locale || I18n.default_locale
  end

  def set_timezone
    Time.zone = logged_in? ? current_user.timezone : browser_timezone
  end
  
  def set_calendar
    @calendar = (current_account ? current_account.calendar : Calendar.gregorian)
  end
  
  def calendar
    @calendar
  end

  def current_account
    current_user.account if current_user
  end

  def request_has_subdomains?
    request.subdomains.size > 0
  end
  
  # First subdomain is the account name.  Note that this relies
  # on prefiltering the wwww subdomain in the web server or dns
  def account_subdomain
    request.subdomains.first
  end
  
  def login_controller?
    params[:controller] == "sessions"
  end

  # The browsers give the # of minutes that a local time needs to add to
  # make it UTC, while TimeZone expects offsets in seconds to add to 
  # a UTC to make it local.
  def browser_timezone
    return nil if cookies[:tzoffset].blank?
    @browser_timezone = begin
      cookies[:tzoffset].to_i.hours
    end
    @browser_timezone
  end
  
  def users_ip_address
    request.env["HTTP_X_REAL_IP"] || request.remote_addr || request.remote_ip
  end

  def browser
    request.env["HTTP_USER_AGENT"]
  end

end
