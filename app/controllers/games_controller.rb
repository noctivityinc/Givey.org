class GamesController < ApplicationController
  before_filter :require_user
  before_filter :check_for_wipe, :check_for_existing_game, :check_for_official_completed_game, :only => [:new]
  before_filter :get_game, :validate_game_user, :except => [:create, :new, :index, :needs_friends]
  before_filter :get_all_friends, :only => [:create]
  before_filter :winner?, :only => [:show, :duel]

  helper_method :total_battles, :finals?, :allow_skip?

  def new
    unless production?
      # remove any old games they might have tried
      current_user.games.destroy_all
    end
  end

  def create
    if unfinished_games?
      render :json => {:status => 'complete', :url => url_for(current_user.games.incomplete.first)} # => do this in case back button selected
    else
      num_friends_needed = get_total_candidates[0]
      if num_friends_needed > 0
        game = current_user.games.create!({:total_candidates => num_friends_needed, :friends_hash => create_friends_hash(num_friends_needed)})
        create_duels(game, game.friends_hash.keys, 1)
        select_subs(game)
        render :json => {:status => 'complete', :url => url_for(game)}
      else
        render :json => {:status => 'complete', :url => needs_friends_games_url}
      end
    end
  end

  def show
    unless @game.winner
      @duel = @game.duels.unplayed.first
      get_challengers
      get_winners_hash
      @npo = Npo.pick
    end
  end

  def duel
    if params[:sub]
      Duel.update(params[:duel], :active => false)
      @game.duels.replace_sub
    else
      Duel.update(params[:duel], :winner_uid => params[:uid])
    end

    @duel = get_next_duel

    if @duel
      get_challengers
      current_round = @game.duels.maximum('round')
      render :json => {:status => 'duel', :html => render_to_string(:partial => "challenger", :collection => @challengers), :round => current_round, :total_battles => total_battles, :duel_count => @game.duels.played.size+1, :finals => finals?, :allow_skip => allow_skip?}
    else
      @game.update_attribute(:winner_uid, params[:uid])
      render :json => {:status => 'winner', :html => render_to_string(:partial => "winner_overlay")}
    end
  end

  def finals?
    (total_battles - 1 == @game.duels.played.size) || (total_battles.to_i == 1)
  end

  def get_next_duel
    if @game.duels.unplayed.empty?
      current_round = @game.duels.maximum('round')
      return nil unless create_duels(@game, @game.duels.winners_for_round(current_round),current_round+1)
    end
    @game.duels.unplayed.first
  end

  def winners
    get_winners_hash
    render :partial => "winners"
  end

  def redo
    @game.update_attribute(:official, false)
    session[:redo] = true
    session[:previous_game_id] = @game.id
    redirect_to :action => :new
  end

  def share
    if (current_user.email == 'give@givey.org') || production?
      begin
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        post_to_wall
        notify_winner_via_wall
      rescue Exception => e
      end
    end
    redirect_to new_donation_path(:gid => @game.id)
  end

  private

    def validate_game_user
      redirect_to root_url, :notice => "Why not start your own experiment!?" unless @game.user == current_user
    end

    def get_game
      @game = current_user.games.find(params[:id]) rescue nil
      redirect_to new_game_path(), :notice => "That game could not be found.  Let's create a new one..." unless @game
    end

    def check_for_wipe
      if (params[:wipe] == '1')
        current_user.games.incomplete.each do |game|
          game.destroy if (game.user == current_user)
        end

        redirect_to new_game_path
      end
    end

    def check_for_existing_game
      redirect_to root_url, :notice => "You have some unfinished games"  if unfinished_games?
    end

    def check_for_official_completed_game
      redirect_to complete_game_path(current_user.games.official.complete.first) if current_user.completed_an_official_game && !session[:redo] && production?
    end

    def get_all_friends
      if current_user
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        begin
          @all_friends =  @fb.fql("SELECT uid, name, first_name, last_name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status,
                current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb 
                FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY rand()")
          process_exclude_list
        rescue Exception => e
          cookies[:user_id] = {:value => nil}
          # redirect_to root_url, :notice => "You must be logged into facebook to create an experiment."
          redirect_to root_url, :alert => e.message
        end
      else
        redirect_to root_url, :notice => "You must be logged into facebook to play the game."
      end unless unfinished_games?
    end

    def process_exclude_list
      if session[:redo]
        session[:redo] = nil
        previous_game = Game.find(session[:previous_game_id])
        session[:previous_game_id] = nil

        @must_include = previous_game.winner
        @all_friends.reject! {|x| previous_game.friends_hash.keys.include?(x.uid.to_s) && x.uid.to_s != @must_include.uid.to_s}
      end
    end

    def create_friends_hash(num_friends_to_select)
      friend_list = get_friend_list(num_friends_to_select+total_subs)
      friend_list_ids = friend_list.map {|x| x.uid}

      friend_pics = @fb.fql("SELECT owner, src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner IN (#{friend_list_ids.join(',')}) AND (type = 'profile' OR type = 'wall'))")
      friend_list.each { |f| f.photos = friend_pics.select {|x| (x.owner.to_s == f.uid.to_s)}}
      friends_hash = friend_list.inject({}) {|r,x| r.merge!({x.uid.to_s => x})}
      friends_hash
    end

    def get_friend_list(num_to_select)
      friend_list = @all_friends.sort_by{rand}[0..(num_to_select-1)]
      unless @must_include.blank?
        friend_list.pop
        friend_list.push(@must_include)
      end
      friend_list
    end

    def total_subs()
      @all_friends.size >= 39 ? 3 : 0
    end

    def get_challengers
      @challengers = @duel.challengers.inject([]) {|r,x| r << @game.friends_hash[x.uid]}
    end

    def winner?
      if @game.winner && @game.official
        # TODO change this to redirect to winner page or share
        # redirect_to complete_game_url, :notice => 'duels complete'
        # render :json => {:status => 'winner', :html => render_to_string(:partial => "winner_overlay")}
      end
    end

    def get_total_candidates()
      if @all_friends.size > 1
        Duel::DUEL_SIZES.detect {|x| @all_friends.size >= x[0]}
      else
        return 0
      end
    end

    def total_battles()
      Duel::DUEL_SIZES.detect {|x| x[0] == @game.total_candidates}[1]
    end

    def create_duels(game, friend_list, round)
      case
      when friend_list.size % 6 == 0 then
        return create_duel(game, friend_list, round, 3)
      when friend_list.size % 4 == 0 then
        return create_duel(game, friend_list, round, 2)
      when friend_list.size % 3 == 0 then
        return create_duel(game, friend_list, round, 3)
      when (friend_list.size > 3) && (friend_list.size % 3) == 2 then
        return create_duel(game, friend_list, round, 3)
      when friend_list.size % 2 == 0 then
        return create_duel(game, friend_list, round, 2)
      else
        return nil
      end
    end

    def create_duel(game, friend_list, round, group_size)
      friend_list.in_groups_of(group_size).each { |x| game.duels.create!(:round => round, :challenger_uids => x.compact, :is_sub => false, :active  => true) }
      return true
    end

    def select_subs(game)
      # => reverse since a must include would be at the end
      game.duels.first.update_attribute(:is_sub, true) if game.total_candidates == 36
    end

    def allow_skip?
      @game.duels.subs.exists? && @game.duels.maximum('round') == 1
    end

    def get_winners_hash
      current_round = @game.duels.maximum('round')
      @winners_hash = 1.upto(current_round).inject({:current_round => current_round}) {|res, round|
        res.merge!({round.to_s => @game.duels.winners_for_round(round).reverse.inject([]) {|r,x| r << @game.friends_hash[x]}})
      }
    end

    def post_to_wall
      if params[:game][:posted_to_wall] == '1'
        @fb.post('me', :type => :feed, :params => {
                   :link => "http://#{APP_CONFIG[:domain]}/#{current_user.givey_token}",
                   :name => "#{@game.winner} is going to save the world.",
                   :caption => "I'm pretty sure #{@game.winner} can save the world.",
                   :description => "I just played Givey.org's game changer.  My money's on #{@game.winner.name} to change the world.  What do you think?",
                   :message => "Just voted #{@game.winner.name} most likely to change the world out of my Facebook friends on Givey."
        })
        @game.update_attribute(:posted_to_wall,true)
      end
    end

    def notify_winner_via_wall
      if params[:game][:notified_winner] == '1'
        @fb.post(@game.winner_uid, :type => :feed, :params => {
                   :message => 'I just voted you as my most likely to change the world Facebook friend.  If others agree, you will get $25,000 to split among causes you care about.  You need to accept my nomination by visiting Givey.',
                   :link => "http://#{APP_CONFIG[:domain]}/c/#{@game.token}"
        })
        @game.update_attribute(:notified_winner,true)
      end
    end

end
