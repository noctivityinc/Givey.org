class HomeController < ApplicationController
  before_filter :check_current_user, :only => :index 

  def index
  end

  def show
    @user = User.find_by_givey_token(params[:token])
    if @user
      session[:referring_id] = @user.id
      
      # signout existing user in case someone is signed in.
      current_user.log_out! if current_user
      cookies[:user_id] = {:value => nil}
    end
    redirect_to root_url
  end

  private

    def check_current_user
      if current_user 
        @fb = MiniFB::OAuthSession.new(current_user.token)
        begin
          @res = @fb.fql("SELECT uid, name, pic_square FROM user WHERE uid = me() OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
        rescue Exception => e
          cookies[:user_id] = {:value => nil}
        end

        if current_user.completed_an_official_game
          redirect_to complete_game_path(current_user.games.official.complete.first)
        end
      end
    end

end
