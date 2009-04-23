class UsersController < ApplicationController
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = I18n.t(:signup_complete)
    else
      flash[:error]  = I18n.t(:signup_problem)
      render :action => 'new'
    end
  end
  
  def index
    conditions = conditions_from_search(params[:search])
    @users = User.find(:all, :conditions => conditions)
    render :partial => 'user', :collection => @users
  end
  
private
  def conditions_from_search(search)
    return '' if search.blank?
    conditions = []
    names = search.split(' ').map(&:strip)
    names.each do |name|
      conditions << "first_name LIKE '%#{quote_string(name)}%' OR last_name LIKE '%#{quote_string(name)}%' or email LIKE '%#{quote_string(name)}%'" unless name.blank?
    end
    conditions.join(' OR ')
  end

  def quote_string(string)
    ActiveRecord::Base.connection.quote_string(string)
  end
      
end
