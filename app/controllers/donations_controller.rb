class DonationsController < ApplicationController
  before_filter :require_user
  
  def new
    session[:donation_pending] = true
    session[:donation_complete] = false
  end
    
  def index
    @donations = Donation.all
  end
    
  def callback
    if session[:donation_pending] && current_user.donations.verify_and_create(current_user, params[:transaction])
      session[:donation_pending] = false # => prevents duplicate recording of donation since its a GET request
      session[:donation_complete] = true
      redirect_to sparks_path()
    else
      redirect_to sparks_path
    end
  end

end
