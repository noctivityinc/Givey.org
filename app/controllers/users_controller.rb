class UsersController < ApplicationController
  def update
    @user = User.find_by_givey_token(params[:id])
    params[:user][:npo_id] = params[:other_npo_id] if params[:other_npo_id]

    if @user.update_attributes(params[:user])
      post_to_wall
      respond_to do |wants|
        wants.html { redirect_to params[:to] }
        wants.js { render :json  => {:status => "saved"} }
      end
    else
      render :json  => @user.errors
    end
  end
  
  private 
  
  def post_to_wall
    if params[:user][:post_story_to_wall] == '1' && production?
      current_user.post_to_wall({:caption => "We're looking for the most altruistic person on Facebook", :description => "Givey.org is giving $5,000 to the top cause voted on by the most altruistic people on Facebook.  Could be you.", :message => "I'm supporting #{current_user.npo.name} to win this Givey.org round of $5,000."})
    end
  end
end
