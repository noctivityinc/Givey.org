class CampaignsController < ApplicationController
  before_filter :login_user

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(params[:campaign])
    if @campaign.save
      flash[:notice] = "Successfully created campaign."
      redirect_to @campaign
    else
      render :action => 'new'
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.update_attributes(params[:campaign])
      flash[:notice] = "Successfully updated campaign."
      redirect_to @campaign
    else
      render :action => 'edit'
    end
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "Successfully destroyed campaign."
    redirect_to campaigns_url
  end
  
  private
  
  def login_user
    if current_user
      @fb = MiniFB::OAuthSession.new(current_user.token)
      begin
        @res = @fb.me
      rescue Exception => e
        cookies[:user_id] = {:value => nil}
        redirect_to root_url, :notice => "You must be logged into facebook to create a campaign."
      end
    else
      redirect_to root_url, :notice => "You must be logged into facebook to create a campaign."
    end
    
  end
end
