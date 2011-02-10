# == Schema Information
#
# Table name: users
#
#  id                           :integer         not null, primary key
#  provider                     :string(255)
#  uid                          :string(255)
#  email                        :string(255)
#  name                         :string(255)
#  gender                       :string(255)
#  locale                       :string(255)
#  profile_pic                  :string(255)
#  token                        :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  admin                        :boolean
#  location                     :text
#  givey_token                  :string(255)
#  referring_id                 :integer
#  candidate                    :boolean
#  candidates_story             :text
#  candidate_post_story_to_wall :boolean
#  profile                      :text
#  candidates_npo_id            :integer
#

class User < ActiveRecord::Base
  serialize :location
  serialize :profile

  before_create :generate_givey_token

  belongs_to :referring_friend, :class_name => "User", :foreign_key => "referring_id"
  has_one :profile, :class_name => "Profile", :foreign_key => "uid", :primary_key => "uid", :dependent => :destroy
  has_many :friends, :dependent => :destroy  do
    def pick(n=3)
      self.sort_by{rand}[0..(n-1)]
    end

    def outdated?
      return maximum(:created_at) < 3.days.ago
    end
  end

  has_many :sparks, :dependent => :destroy do
    def goal
      return case self.decided.count
      when 0..20 then '20'
      when 21..50 then'50'
      when 51..100 then '100'
      else '5000'
      end
    end
  end
  
  has_one :candidates_npo, :class_name => "Npo", :foreign_key => "candidates_npo_id"
  
  scope :candidates, where(:candidate => true)

  def admin?
    self.admin
  end

  def first_name
    self.name.split(/\s/)[0]
  end

  def prepare_a_spark
    return sparks.undecided.first if sparks.undecided.first

    question = Question.active.sort_by{rand}.first
    spark_friends = self.friends.pick
    unless spark_friends.empty?
      prepare_a_spark if !self.sparks.create!(:question => question, :friend_uid_1 => spark_friends[0].uid, :friend_uid_2 => spark_friends[1].uid, :friend_uid_3 => spark_friends[2].uid)
    end
    return sparks.undecided.first
  end

  def referral_link
    return "http://#{APP_CONFIG[:domain]}/#{self.givey_token}"
  end

  def self.create_with_mini_fb(fb, location, referring_id)
    create! do |user|
      user.provider = 'facebook'
      user.uid = fb.id
      user.location = location
      user.referring_id = referring_id
      user.candidate_post_story_to_wall = true # set to true.  let them uncheck
    end
  end

  def update_with_mini_fb(fb,access_token)
    self.name = fb.me.name
    self.email = fb.me.email rescue nil
    self.gender = fb.me.sex rescue nil
    self.locale = fb.me.locale rescue nil
    self.token = access_token
    save!
  end

  def log_out!
    # self.token = nil
    # save!
  end

  def to_param
    self.givey_token
  end

  def get_friends
    @fb ||= MiniFB::OAuthSession.new(self.token)
    res = @fb.multifql({:all_friends => all_friends_fql, :photos => photos_fql})
    friends = combine_friends_and_photos(res)
    save_friends(friends)
    return true
  end
  
  def destroy_and_get_friends
    self.friends.destroy_all
    self.get_friends
  end

  private

    def generate_givey_token
      self.givey_token = rand(36**8).to_s(36)
    end

    def all_friends_fql
      exclude_list = self.friends.map {|x| x.uid}
      exclude_sql = exclude_list.empty? ? '' : "AND uid2 <> #{exclude_list.join(' AND uid2 <> ')}"
      return "SELECT uid, name, first_name, last_name, pic, pic_square, pic_big, religion, birthday, sex, relationship_status,
            current_location, significant_other_id, political, activities, interests, movies, books, about_me, quotes, profile_blurb 
            FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() #{exclude_sql}) ORDER BY rand() LIMIT 40"
    end

    def photos_fql
      return "SELECT owner, src, caption, link FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner IN (SELECT uid FROM #all_friends) AND (type = 'profile' OR type = 'wall'))"
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
        self.friends.create!(:uid => f.uid.to_s)
        profile = Profile.where(:uid => f.uid.to_s).where('updated_at > ?',1.day.ago)
        Profile.create!(:uid => f.uid, :details => f.details, :photos => f.photos) if profile.empty?
      end
    end

end
