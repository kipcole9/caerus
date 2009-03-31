class UserMailer < ActionMailer::Base
  def send_campaign(campaign, recipient)
    @recipients   = recipient.email
    @subject      = campaign.subject
    @body[:url]   = campaign.link_to + "&cid=#{campaign.id}&uid=#{recipient.id}"
  end
end
