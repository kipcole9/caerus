class ClicksController < ApplicationController
  before_filter         :find_campaign

  # Add a new click to the database and redirect
  def click
    @click = Click.create!(:campaign_id => @campaign, :responder_id => params[:uid], :browser => browser, :ip_address => ip_address)
    if @campaign.redirection
      redirect_to @campaign.redirection
    else
      render :text => "Click received, thanks."
    end
  end
  
private
  def find_campaign
    @campaign = Campaign.find(params[:cid])
  end
  
  
end
