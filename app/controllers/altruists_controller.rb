class AltruistsController < ApplicationController
  def index
    @altruists = User.scorable.with_causes.paginate :page => params[:page], :per_page => 10
  end
  
  def show
    redirect_to root_url, :notice => "You need to be logged in to view an altruists details" unless current_user 
    @altruist = Profile.find_by_givey_token(params[:id])
  end
end
