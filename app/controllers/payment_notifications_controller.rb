class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    campaign = Campaign.find_by_id(params[:invoice])
    if campaign
      p = PaymentNotification.create!(:params => params, :campaign_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:txn_id] )
      render :text => p.to_yaml
    else
      render :text => "campaign not found"
    end
  end
end
