class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(cookies[:user_id]) unless cookies[:user_id].blank? 
  end
end
