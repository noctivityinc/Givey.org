class HomeController < ApplicationController
  before_filter :check_current_user, :only => [:index, :beta_test]
  before_filter :require_user, :only => [:beta_test]

  def index
  end

  def show
    @user = User.find_by_givey_token(params[:token])
    if @user
      session[:referring_id] = @user.id

      if production?
        # signout existing user in case someone is signed in.
        current_user.log_out! if current_user
        cookies[:user_id] = {:value => nil}
      end
    end

    unless @user && @user.completed_an_official_game
      redirect_to root_url
    end
  end

  private

    def check_current_user
      if current_user
        @fb = MiniFB::OAuthSession.new(current_user.token)
        begin
          @res = @fb.me
        rescue Exception => e
          cookies[:user_id] = {:value => nil}
        end

        if current_user.completed_an_official_game && production?
          redirect_to complete_game_path(current_user.games.official.complete.first)
        end
      end
    end

    def require_user
      redirect_to '/not_yet' unless current_user
    end

end
