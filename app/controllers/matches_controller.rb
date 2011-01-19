class MatchesController < ApplicationController
  before_filter :get_campaign, :only => [:create, :new, :index]
  before_filter :get_all_friends, :only => [:create]
  before_filter :get_match, :except => [:create, :new, :index]
  before_filter :duel_complete?, :only => [:show]

  def new

  end

  def create
    num_friends_to_select = total_duelers(@all_friends.size)[0]
    friend_list = @all_friends.sort_by{rand}[0..(num_friends_to_select-1)]
    friend_list_ids = friend_list.map {|x| x.uid}
    friend_pics = @fb.fql("SELECT owner, src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner IN (#{friend_list_ids.join(',')}) AND (type = 'profile' OR type = 'wall'))")
    friend_list.each { |f| f.photos = friend_pics.select {|x| (x.owner.to_s == f.uid.to_s)}}
    friends_hash = friend_list.inject({}) {|r,x| r.merge!({x.uid.to_s => x})}

    match = @campaign.matches.create!({:user => current_user, :friends_hash => friends_hash})
    create_duels(match, match.friends_hash.keys, 1)

    render :json => {:status => 'complete', :url => url_for(match)}
  end

  def show
    @duel = @match.duels.unplayed.first
    @challengers = @duel.challenger_uids.inject([]) {|r,x| r << @match.friends_hash[x]}
    @duel_count = @match.duels.played.size
    @total_duels = total_number_of_duels
    get_winners_hash
  end

  def duel
    Duel.update(params[:duel], :winner_uid => params[:uid])
    @duel = get_next_duel

    if @duel
      @challengers = @duel.challenger_uids.inject([]) {|r,x| r << @match.friends_hash[x]}
      current_round = @match.duels.maximum('round')
      render :json => {:status => 'duel', :html => render_to_string(:partial => "challenger", :collection => @challengers), :round => current_round, :total_duels => total_number_of_duels, :duel_count => @match.duels.played.size, :finals => (total_number_of_duels - 1 == @match.duels.played.size)}
    else
      @match.update_attribute(:winner_uid,params[:uid])
      render :json => {:status => 'winner', :html => render_to_string( :partial => "winner", :locals => {:winner => @match.winner}), :round => current_round, :total_duels => total_number_of_duels, :duel_count => @match.duels.played.size}
    end
  end

  def get_next_duel
    if @match.duels.unplayed.empty?
      current_round = @match.duels.maximum('round')
      return nil unless create_duels(@match, @match.duels.winners_for_round(current_round),current_round+1)
    end
    @match.duels.unplayed.first
  end

  def winners
    get_winners_hash
    render :partial => "winners"
  end

  private

    def get_all_friends
      if current_user
        @fb ||= MiniFB::OAuthSession.new(current_user.token)
        begin
          @all_friends =  @fb.fql("SELECT uid, name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status, current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
        rescue Exception => e
          cookies[:user_id] = {:value => nil}
          # redirect_to root_url, :notice => "You must be logged into facebook to create an experiment."
          redirect_to root_url, :alert => e.message
        end
      else
        redirect_to root_url, :notice => "You must be logged into facebook to create a campaign."
      end
    end

    def get_campaign
      @campaign = Campaign.find(params[:campaign_id]) rescue nil
      redirect_to new_campaign_url, :notice => "Please try again..." unless @campaign
    end

    def get_match
      @match = Match.find(params[:id]) rescue nil
      @match ||= Match.find(params[:match_id]) rescue nil
      redirect_to new_campaign_match_path(@campaign), :notice => "Please try again..." unless @match
    end
    
    def duel_complete?
      if @match.duels.unplayed.empty?
        redirect_to 
      end
    end

    DUEL_SIZES = [[36, 17],[30, 4], [24, 4], [20, 4], [18, 3]]
    def total_duelers(all_friends_size)
      if all_friends_size > 0
        DUEL_SIZES.detect {|x|  all_friends_size >= x[0]}
      end
    end
    
    def total_number_of_duels
      DUEL_SIZES.detect {|x| x[0] == @match.friends_hash.size}[1]
    end

    def create_duels(match, friend_list, round)
      case
      when friend_list.size % 6 == 0 then
        return create_duel(match, friend_list, round, 3)
      when friend_list.size % 4 == 0 then
        return create_duel(match, friend_list, round, 2)
      when friend_list.size % 3 == 0 then
        return create_duel(match, friend_list, round, 2)
      when (friend_list.size > 3) && (friend_list.size % 3) == 2 then
        return create_duel(match, friend_list, round, 3)
      when friend_list.size % 2 == 0
        return create_duel(match, friend_list, round, 2)
      else
        return nil
      end
    end

    def create_duel(match, friend_list, round, group_size)
      friend_list.in_groups_of(group_size).each { |x| match.duels.create(:round => round, :challenger_uids => x.compact) }
      return true
    end

    def get_winners_hash
      current_round = @match.duels.maximum('round')
      @winners_hash = 1.upto(current_round).inject({:current_round => current_round}) {|res, round|
        res.merge!({round.to_s => @match.duels.winners_for_round(round).inject([]) {|r,x| r << @match.friends_hash[x]}})
      }
    end


end
