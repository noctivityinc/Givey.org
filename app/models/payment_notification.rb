# == Schema Information
#
# Table name: payment_notifications
#
#  id             :integer         not null, primary key
#  params         :text
#  status         :string(255)
#  transaction_id :string(255)
#  campaign_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class PaymentNotification < ActiveRecord::Base
  belongs_to :campaign
  serialize :params
  after_create :mark_purchase_complete_for_campaign

  private
    def mark_purchase_complete_for_campaign
      if status == "Completed" && params[:secret] == APP_CONFIG[:paypal]['secret'] &&  
          params[:receiver_email] == APP_CONFIG[:paypal]['email'] &&  
          params[:mc_gross] == campaign.donation_amount
        campaign.update_attributes(:payment_completed_at => Time.now)
      end
    end
end
