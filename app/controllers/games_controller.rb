class GamesController < ApplicationController
  before_filter :require_user
  before_filter :check_for_wipe, :check_for_existing_game, :check_for_official_completed_game, :only => [:new]
  before_filter :get_game, :validate_game_user, :except => [:create, :new, :index]
  before_filter :get_all_friends, :only => [:create]
  before_filter :winner?, :only => [:show]

  helper_method :total_number_of_duels

  def new
  end

  def create
    if unfinished_games?
      render :json => {:status => 'complete', :url => url_for(current_user.games.incomplete.first)} # => do this in case back button selected
    else
      game = current_user.games.create!({:friends_hash => create_friends_hash})
      create_duels(game, game.friends_hash.keys, 1)
      render :json => {:status => 'complete', :url => url_for(game)}
    end
  end

  def show
    unless @game.winner
      @duel = @game.duels.unplayed.first
      @challengers = @duel.challenger_uids.inject([]) {|r,x| r << @game.friends_hash[x]}
      @total_duels = total_number_of_duels
      get_winners_hash
    end
  end

  def duel
    Duel.update(params[:duel], :winner_uid => params[:uid])
    @duel = get_next_duel

    if @duel
      @challengers = @duel.challenger_uids.inject([]) {|r,x| r << @game.friends_hash[x]}
      current_round = @game.duels.maximum('round')
      render :json => {:status => 'duel', :html => render_to_string(:partial => "challenger", :collection => @challengers), :round => current_round, :total_duels => total_number_of_duels, :duel_count => @game.duels.played.size+1, :finals => (total_number_of_duels - 1 == @game.duels.played.size) || (total_number_of_duels.to_i == 1)}
    else
      @game.update_attribute(:winner_uid, params[:uid])
      render :partial => "winner_overlay"
    end
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

  private

    def require_user
      redirect_to root_url, :notice => "You must be logged into facebook to create a game." unless current_user
    end

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
      redirect_to complete_game_path(current_user.games.official.complete.first) if current_user.completed_an_official_game
    end


    def get_all_friends
      if current_user
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        begin
          if params[:redo] 
            previous_game = current_user.games.find(params[:gid])
            include_uid = previous_game.winner_uid
            exclude_uids = (previous_game.friends_hash.keys - include_uid)
          end 
          exclusion_list = [].join(',')
          @all_friends =  @fb.fql("SELECT uid, name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status,
                current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb 
                FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY rand() LIMIT 10")
        rescue Exception => e
          cookies[:user_id] = {:value => nil}
          # redirect_to root_url, :notice => "You must be logged into facebook to create an experiment."
          redirect_to root_url, :alert => e.message
        end
      else
        redirect_to root_url, :notice => "You must be logged into facebook to play the game."
      end unless unfinished_games?
    end

    def create_friends_hash
      num_friends_to_select = total_duelers(@all_friends.size)[0]
      friend_list = @all_friends.sort_by{rand}[0..(num_friends_to_select-1)]
      friend_list_ids = friend_list.map {|x| x.uid}
      friend_pics = @fb.fql("SELECT owner, src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner IN (#{friend_list_ids.join(',')}) AND (type = 'profile' OR type = 'wall'))")
      friend_list.each { |f| f.photos = friend_pics.select {|x| (x.owner.to_s == f.uid.to_s)}}
      friends_hash = friend_list.inject({}) {|r,x| r.merge!({x.uid.to_s => x})}
    end

    def winner?
      if @game.winner && @game.official
        # TODO change this to redirect to winner page or share
        # redirect_to complete_game_url, :notice => 'duels complete'
      end
    end

    def total_duelers(all_friends_size)
      if all_friends_size > 0
        Duel::DUEL_SIZES.detect {|x|  all_friends_size >= x[0]}
      end
    end

    def total_number_of_duels
      Duel::DUEL_SIZES.detect {|x| x[0] == @game.friends_hash.size}[1]
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
      when friend_list.size % 2 == 0
        return create_duel(game, friend_list, round, 2)
      else
        return nil
      end
    end

    def create_duel(game, friend_list, round, group_size)
      friend_list.in_groups_of(group_size).each { |x| game.duels.create(:round => round, :challenger_uids => x.compact) }
      return true
    end

    def get_winners_hash
      current_round = @game.duels.maximum('round')
      @winners_hash = 1.upto(current_round).inject({:current_round => current_round}) {|res, round|
        res.merge!({round.to_s => @game.duels.winners_for_round(round).reverse.inject([]) {|r,x| r << @game.friends_hash[x]}})
      }
    end


end