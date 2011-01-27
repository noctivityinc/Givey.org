class CandidatesController < ApplicationController
  skip_after_filter :record_previous_page, :only => :new 
  before_filter :require_user, :except => [:new, :index, :show] 
  
  def new
    @game = Game.find_by_token(params[:token])
    redirect_to root_url, :notice => "That link is invalid." unless @game
    session[:game_id] = @game.id
    session[:previous_page] = story_candidates_path(:gid => @game.id)
  end

  def story
    @game = Game.find(params[:gid])
    redirect_to root_url, :alert => "There was a problem.  We've been notified.  Sorry." unless @game
    current_user.update_attribute(:candidate, true)
    @cause = Npo.pick
  end

  def submit_story
    current_user.update_attributes(params[:user])
    current_user.reload
    post_to_candidates_wall
    redirect_to candidates_path, :notify => "Story Submitted!"
  end

  def index
    @candidates = User.candidates.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 9
  end
  
  def show
    @candidate = User.find_by_id(params[:id])
    # get_friends
  end

  private

    def post_to_candidates_wall
      begin
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        if current_user.candidate_post_story_to_wall
          @fb.post('me', :type => :feed, :params => {
                     :link => "http://#{APP_CONFIG[:domain]}/#{current_user.givey_token}",
                     :name => "Givey.org",
                     :caption => "Let's Change The World, Shall We?",
                     :description => "Together we are giving $25,000 to the most trusted friend on Facebook.  Could that be you?",
                     :message => current_user.candidates_story
          })
        end
      rescue Exception => e
      end
    end
    
    def get_friends
      begin
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        @friends =  @fb.fql("SELECT name, pic_square FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY rand() LIMIT 22")
      rescue Exception => e
        @friends = []
      end
    end
end
