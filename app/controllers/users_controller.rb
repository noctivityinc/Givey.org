class UsersController < ApplicationController
  def update
    @user = User.find_by_givey_token(params[:id])
    params[:user][:npo_id] = params[:other_npo_id] if params[:other_npo_id]

    if @user.update_attributes(params[:user])
      respond_to do |wants|
        wants.html { redirect_to params[:to] }
        wants.js { render :json  => {:status => "saved"} }
      end
    else
      render :json  => @user.errors
    end
  end
end
