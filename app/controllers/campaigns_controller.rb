class CampaignsController < ApplicationController
  before_filter :require_user
  before_filter :get_campaign, :validate_user, :except => [:new, :create] 
  before_filter :check_for_existing_match, :except => "in_progress" 

  def new
  end
  
  def create
    @campaign = current_user.campaigns.create!
    redirect_to new_campaign_match_path(@campaign)
  end

  def paypal_redirect
    if @campaign.friends_hash.count < @campaign.slots_available
      redirect_to friends_campaign_path(@campaign), :alert => "You haven't selected enough friends.  Let's try again."
    end
  end

  private

    def require_user
      redirect_to root_url, :notice => "You must be logged into facebook to create an experiment." unless current_user
    end

    def validate_user
      redirect_to new_campaign_path, :notice => "Why not start your own experiment!?" unless @campaign.user == current_user
    end

    def get_campaign
      @campaign = Campaign.find(params[:id]) rescue nil
      redirect_to new_campaign_url, :notice => "Please try again..." unless @campaign
    end
    
    def check_for_existing_match
      redirect_to in_progress_campaign_path(current_user.matches.incomplete.first.campaign) unless current_user.matches.incomplete.empty?
    end

end
