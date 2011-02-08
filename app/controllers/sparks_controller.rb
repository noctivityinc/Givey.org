class SparksController < ApplicationController
  before_filter :require_user
  before_filter :load_friends, :only => :create

  def create
    render :json => {:status => 'complete', :url => sparks_path}
  end

  def index
    @spark = current_user.prepare_a_spark
  end

  private

    def require_user
      redirect_to root_url, :notice => "Please login to play" unless current_user
    end

    def load_friends
      if current_user.friends.count < 20 || current_user.friends_outdated?
        current_user.friends.destroy_all
        get_friends.get_friends
      end
    end

end
