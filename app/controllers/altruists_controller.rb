class AltruistsController < ApplicationController
  def index
    @altruists = User.scorable.with_causes.paginate :page => params[:page], :per_page => 10
  end
  
  def show
    @altruist = Profile.find_by_givey_token(params[:id])
  end
end
