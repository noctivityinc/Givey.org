class DonationsController < ApplicationController
  before_filter :get_game
  
  def index
    @donations = Donation.all
  end
  
  def show
    @donation = Donation.find(params[:id])
  end
  
  def new
    @donation = Donation.new
  end
  
  def create
    @donation = Donation.new(params[:donation])
    if @donation.save
      flash[:notice] = "Successfully created donation."
      redirect_to @donation
    else
      render :action => 'new'
    end
  end
  
  def edit
    @donation = Donation.find(params[:id])
  end
  
  def update
    @donation = Donation.find(params[:id])
    if @donation.update_attributes(params[:donation])
      flash[:notice] = "Successfully updated donation."
      redirect_to donation_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @donation = Donation.find(params[:id])
    @donation.destroy
    flash[:notice] = "Successfully destroyed donation."
    redirect_to donations_url
  end
  
  private

  def get_game
    if params[:gid]
      @game = Game.find(params[:gid])
    end
  end
end
