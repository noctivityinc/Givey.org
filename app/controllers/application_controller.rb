class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :record_previous_page

  helper_method :current_user, :facebook_oauth_callback_url, :unfinished_games?, :production?

  def facebook_oauth_callback_url
    return "http://#{request.host_with_port}/auth/facebook/callback"
  end

  def redirect_back(default_url=nil)
    session_page = session[:previous_page]
    session[:previous_page] = nil
    redirect_to (session_page || default_url)
  end
  
  def redirect_forward_or_to(default_url=nil)
    session_page = session[:next_page]
    session[:next_page] = nil
    redirect_to (session_page || default_url)
  end
  
  def production?
    Rails.env == 'production'
  end

  def require_user
    redirect_to root_url, :notice => "Please log in to continue." unless current_user
  end


  private

    def current_user
      @current_user ||= User.find_by_id(cookies[:user_id]) unless cookies[:user_id].blank?
    end

    def record_previous_page
      session[:previous_page] = request.url
    end
    
    def unfinished_games?
      !current_user.games.incomplete.empty?
    end
end
