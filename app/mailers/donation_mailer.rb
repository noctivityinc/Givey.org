class DonationMailer < ActionMailer::Base
  default :from => "give@givey.org"
  
  def skipped_donation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Contributing to the Givey.org Movement")
  end
end
