class FriendsController < ApplicationController
  before_filter :get_friend

  def create
    respond_to do |wants|
      wants.html { redirect_to sparks_url }
      wants.js { render :json => {:status => 'complete'} if @user.get_friends }
    end
  end

  def destroy
    @friend = @user.friends.where(:id => params[:id])
    respond_to do |wants|
      if @friend
        wants.html { redirect_to root_url, :notice => "Friend deactivated for #{@user.name}"}
        wants.js { render :json, {:status => "success", :message => "Friend deactivated for #{@user.name}"}}
      else
        wants.html { redirect_to root_url, :alert => "Friend could not be found for #{@user.name}"}
        wants.js { render :json, {:status => "success", :message => "Friend could not be found for #{@user.name}"}}
      end
    end
  end

  private

    def get_friend
      @user = User.find_by_givey_token(params[:user_id])
      respond_to do |wants|
        wants.html { redirect_to root_url, :alert => "User could not be found" }
        wants.js { render :json  => {:status => "error", :message => "User could not be found" }}
      end unless @user
    end
end
