class FriendsController < ApplicationController
  def create
   @user = User.find_by_givey_token(params[:user_id]) 
   render :json => {:status => 'complete'} if @user.get_friends
  end
end