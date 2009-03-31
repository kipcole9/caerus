#
# This class is complicated since it is the responder for both the site that is the "marketing"
# domain and the private subdomains.  This is because today we cannot specify subdomains as
# part of rails routing definitions.
#
# In the production environment there would be two application instances - one for the marketing site
# that handles signup, billing and account management.  The other for the private subdomains.
#
class WelcomesController < ApplicationController
  layout         :splash
  before_filter  { |controller| controller.send("login_required") if controller.request_has_subdomains? }  
  
  def show
    if request_has_subdomains? 
      if current_account
        render "show"
      else
        redirect_to root_url
      end
    else
      render "splash"
    end
  end
  
private
  def splash
    if request_has_subdomains?
      "application"
    else
      "splash"
    end
  end

end
