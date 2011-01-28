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

      if beta_tester_allowed(fb)
        profile = fb.fql("SELECT uid, name, first_name, email, gender, locale, last_name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status,
              current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb 
              FROM user WHERE uid = me()").first
        profile.photos = fb.fql("SELECT src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner = me() AND (type = 'profile' OR type = 'wall'))")

        @user = User.find_by_provider_and_uid('facebook',fb.me.id) || User.create_with_mini_fb(fb.me, GeoLocation.find(request.ip), session[:referring_id])
        @user.update_with_mini_fb(profile, access_token) # => updates to make sure we have latest session key and profile info
        set_user_cookie
        session[:referring_id] = nil
        @user.games.destroy_all if Rails.env == 'staging'
      else
        redirect_to '/not_yet'
      end
    end

    def omniauth_create
      auth = request.env["omniauth.auth"]
      @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      @user.update_with_omniauth(auth) # => updates to make sure we have latest session key and profile info
      set_user_cookie
    end

    def set_user_cookie
      cookies[:user_id] = {:value => @user.id, :expires => 24.hours.from_now }
      redirect_forward_or_to(beta_test_path)
    end
    
    def beta_tester_allowed(fb)
      bt = BetaTester.find_by_email(fb.me.email)
      if bt
        bt.increment!(:access_count)
        bt.update_attribute(:last_accessed_at, Time.now)
      else
        nil
      end
    end
end
