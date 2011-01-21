class SessionsController < ApplicationController

  def create
    if params[:provider] == 'facebook'
      facebook_accepted? ? facebook_create : redirect_to(access_denied_path(:provider => 'facebook'))
    else
      omniauth_create
    end
  end

  def access_denied
    if params[:provider] == 'facebook'
      @oauth_url
      render "access_denied_facebook"
    end
  end

  def destroy
    current_user.log_out! if current_user
    cookies[:user_id] = {:value => nil}
    redirect_to root_url, :notice => "Signed out!"
  end

  private

    def facebook_accepted?
      return params[:error].blank?
    end

    def facebook_create
      access_token_hash = MiniFB.oauth_access_token(APP_CONFIG[:facebook]['api_key'], facebook_oauth_callback_url, APP_CONFIG[:facebook]['app_secret'], params[:code])
      access_token = access_token_hash["access_token"]
      fb = MiniFB::OAuthSession.new(access_token)
      profile_pic = fb.fql("SELECT pic_square FROM user WHERE uid = me()").first.pic_square

      @user = User.find_by_provider_and_uid('facebook',fb.me.id) || User.create_with_mini_fb(fb.me, GeoLocation.find(request.ip))
      @user.update_with_mini_fb(fb.me, profile_pic, access_token) # => updates to make sure we have latest session key and profile info
      set_user_cookie
    end

    def omniauth_create
      auth = request.env["omniauth.auth"]
      @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      @user.update_with_omniauth(auth) # => updates to make sure we have latest session key and profile info
      set_user_cookie
    end

    def set_user_cookie
      cookies[:user_id] = {:value => @user.id, :expires => 24.hours.from_now }
      redirect_to new_game_path
    end
end
