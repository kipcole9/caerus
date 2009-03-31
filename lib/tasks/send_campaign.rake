namespace :thru do
  
  desc "Send Campaign"
  task(:send_campaign => :environment) do
    @campaign = Campaign.find_by_name(ENV["campaign"])
    @campaign.recipients.each do |recipient|
      CampaignMailer.deliver_campaign(@campaign, recipient)
    end
  end
  
end