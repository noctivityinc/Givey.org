class AltruistsController < ApplicationController
  def index
    @altruists = User.scorable.with_causes.paginate :page => params[:page], :per_page => 10
  end

  def show
    redirect_to root_url, :alert => "You need to be logged in to view an altruists details" unless current_user

    @altruist = Profile.find_by_givey_token(params[:id])
    redirect_to root_url, :alert  => "That altruist cannot be found.  Sorry :)" unless @altruist

    if (@altruist.uid == current_user.uid) && !current_user.scores_unlocked?
      redirect_to sparks_path, :alert => "You need to answer 20 questions before you can see what others think of you." 
    end
  end
end
