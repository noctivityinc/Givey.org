class UsersController < ApplicationController
  def update
   @user = User.find_by_givey_token(params[:id]) 
   if @user.update_attributes(params[:user])
     render :json  => {:status => "saved"}     
   else
     render :json  => @user.errors
   end
  end
end