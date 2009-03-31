class AccountsController < ApplicationController
  before_filter     :retrieve_account, :except => [:new, :create]
  layout "new_account"
  
  def new
    @account = Account.new
    @user = @account.users.new
  end
  
  def create
    @account = Account.create(params[:account])
    @user = User.create(params[:user])
    @user.password              = params[:user][:password]   # Because we don't mass assign password
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.account_admin         = true                       # Account creator is always account administrator
    Account.transaction do
      @account.save! 
      @account.users << @user
      @user.save!
    end
    flash[:notice] = I18n.t('accounts.new_account.created')
    redirect_to the_new_account_url
    
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = I18n.t('accounts.new_account.creation_error')
    render :new
  end
  
  def update
    current_account.attributes = params["account"]
    current_account.save!
    head :updated
  end
  
private
  def retrieve_account
    current_user && current_user.is_account_admin? ? current_account : raise(ActiveRecord::RecordNotFound)
  end
  
  def are_subdomains_allowed
    return false if request_has_subdomains?
    true
  end
  
  def the_new_account_url
    "http://#{@account.name}.#{request.host_with_port}/"
  end
  
  def symbolize_keys(hash)
    result = {}
    hash.each {|k,v| result[k.to_sym] = v}
    result
  end
  

end