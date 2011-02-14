class AltruistsController < ApplicationController
  def index
    @altruists = Profile.scorable.by_score.paginate :page => params[:page], :per_page => 10
  end
end
