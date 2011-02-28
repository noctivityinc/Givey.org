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

      if beta_tester_allowed(fb) || mturk_tester(fb)
        @user = User.find_by_provider_and_uid('facebook',fb.me.id)
        unless @user
          User.create_with_mini_fb(fb.me, GeoLocation.find(request.ip), session[:referring_id])
          @new_user = true
        end

        @user.update_with_mini_fb(fb, access_token) # => updates to make sure we have latest session key and profile info

        create_profile(fb)
        UserMailer.welcome(@user).deliver if @new_user

        set_user_cookie
        session[:referring_id] = nil
      else
        redirect_to '/not_yet'
      end
    end

    def create_profile(fb)
      res = fb.multifql({:bio => bio_fql, :photos => photos_fql})
      profile = combine_bio_and_photos(res)
      Profile.create_or_update({:uid => profile.uid.to_s, :details => profile.details, :photos => profile.photos})
    end

    def bio_fql
      return "SELECT uid, name, first_name, last_name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status,
              current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb 
              FROM user WHERE uid = me()"
    end

    def photos_fql
      return "SELECT owner, src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner = me() AND (type = 'profile' OR type = 'wall') LIMIT 9)"
    end

    def combine_bio_and_photos(res)
      bio = res.detect {|x| x.name == 'bio'}.fql_result_set.first rescue nil
      photos = res.detect {|x| x.name == 'photos'}.fql_result_set
      return Hashie::Mash.new({:uid => bio.uid, :details => bio, :photos => photos})
    end

    def set_user_cookie
      cookies[:user_id] = {:value => @user.id, :expires => 24.hours.from_now }
      redirect_back(new_spark_path)
    end

    def mturk_tester(fb)
      if session[:mturk] 
        session[:mturk] = false
        Mturk.find_or_create_by_uid({:uid => fb.me.id})
        return true
      end
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
