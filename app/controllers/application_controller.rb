class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :record_previous_page

  helper_method :current_user, :facebook_oauth_callback_url

  def facebook_oauth_callback_url
    return "http://#{request.host_with_port}/auth/facebook/callback"
  end

  def redirect_back
    redirect_to session[:previous_page]
  end

  private

    def current_user
      @current_user ||= User.find_by_id(cookies[:user_id]) unless cookies[:user_id].blank?
    end

    def record_previous_page
      session[:previous_page] = request.url
    end
end
