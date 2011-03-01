class FriendsController < ApplicationController
  before_filter :verify_user

  def index
    if current_user.friends_scores_unlocked?
      @friends = current_user.friends.active
    else
      redirect_to sparks_path, :alert => "You need to answer 10 questions before you can view what others said about your friends." 
    end
  end

  def create
    render :json => {:status => 'complete'} if current_user.get_friends
  end

  def destroy
    @friend = current_user.friends.where(:id => params[:id])
    respond_to do |wants|
      if @friend
        wants.html { redirect_to root_url, :notice => "Friend deactivated for #{current_user.name}"}
        wants.js { render :json, {:status => "success", :message => "Friend deactivated for #current_user.name}"}}
      else
        wants.html { redirect_to root_url, :alert => "Friend could not be found for #{current_user.name}"}
        wants.js { render :json, {:status => "success", :message => "Friend could not be found for #{current_user.name}"}}
      end
    end
  end

  private

    def verify_user
      respond_to do |wants|
        wants.html { redirect_to root_url, :alert => "User could not be found" }
        wants.js { render :json  => {:status => "error", :message => "User could not be found" }}
      end unless current_user
    end
end
