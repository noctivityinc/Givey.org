class BattlesController < ApplicationController
  before_filter :load_friends, :only => :create

  def create
    battle = current_user.prepare_a_battle
    render :json => {:status => 'complete', :url => url_for(battle)}
  end
  
  def show
    
  end

  private

    def load_friends
      if current_user.friends.empty?
        get_friends
      end
    end

    def get_friends
      @fb ||= MiniFB::OAuthSession.new(current_user.token)
      res = @fb.multifql({:all_friends => all_friends_fql, :photos => photos_fql})
      friends = combine_friends_and_photos(res)
      save_friends(friends)
    end

    def all_friends_fql
      exclude_list = current_user.friends.map {|x| x.uid}
      exclude_sql = exclude_list.empty? ? '' : "AND uid2 <> #{exclude_list.join(' AND uid2 <> ')}"
      return "SELECT uid, name, first_name, last_name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status,
            current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb 
            FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() #{exclude_sql}) ORDER BY rand() LIMIT 40"
    end

    def photos_fql
      return "SELECT owner, src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner IN (SELECT uid FROM #all_friends) AND (type = 'profile' OR type = 'wall') LIMIT 9)"
    end

    def combine_friends_and_photos(res)
      all_friends = res.detect {|x| x.name == 'all_friends'}.fql_result_set
      photos = res.detect {|x| x.name == 'photos'}.fql_result_set
      friends = all_friends.inject([]) {|res,x|
        res << Hashie::Mash.new({:uid => x.uid, :details => x, :photos => photos.select {|p| (p.owner.to_s == x.uid.to_s)}})
      }
      return friends
    end

    def save_friends(friends)
      friends.each do |f|
        current_user.friends.create!(:uid => f.uid)
        Profile.create!(:uid => f.uid, :details => f.details, :photos => f.photos)
      end
    end
end
