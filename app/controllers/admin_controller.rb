class AdminController < ApplicationController
  before_filter :check_for_current_user
  
  def index
  end
  
  private
  
  def check_for_current_user
    unless current_user && current_user.admin?
      redirect_to root_url, :notice => "You are not authorized to access that page." 
    end
  end
end
