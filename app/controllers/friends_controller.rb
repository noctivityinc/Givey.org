class FriendsController < ApplicationController
  before_filter :verify_user
  
  def index
    @friends = current_user.friends # .scorable.paginate :page => params[:page], :per_page => 10
  end

  def create
    respond_to do |wants|
      wants.html { redirect_to sparks_url }
      wants.js { render :json => {:status => 'complete'} if current_user.get_friends }
    end
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
