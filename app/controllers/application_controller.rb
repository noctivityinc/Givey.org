class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :require_admin, :facebook_oauth_callback_url, :production?, :launched?

  def facebook_oauth_callback_url()
    return "http://#{request.host_with_port}/auth/facebook/callback"
  end

  def redirect_back(default_url=nil)
    session_page = session[:previous_page]
    session[:previous_page] = nil
    redirect_to (session_page || default_url)
  end

  def production?
    Rails.env == 'production'
  end
  
  def launched?
    return (Date.today >= Date.parse('2011-03-07') || !production?)
  end

  def require_user
    unless current_user
      record_previous_page
      redirect_to root_url, :notice => "Please click the button below to continue..."
    end
  end

  private

    def current_user
      @current_user ||= User.find_by_id(cookies[:user_id]) unless cookies[:user_id].blank?
    end

    def require_admin
      redirect_to root_url, :notice => 'Unauthorized Access' unless current_user && current_user.admin?
    end

    def record_previous_page
      session[:previous_page] = request.url
    end

    def help
      Helper.instance
    end

    class Helper
      include Singleton
      include ActionView::Helpers::TextHelper
    end
end
