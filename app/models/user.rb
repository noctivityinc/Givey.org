# == Schema Information
#
# Table name: users
#
#  id                         :integer         not null, primary key
#  provider                   :string(255)
#  uid                        :string(255)
#  email                      :string(255)
#  name                       :string(255)
#  gender                     :string(255)
#  locale                     :string(255)
#  token                      :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  admin                      :boolean
#  location                   :text
#  givey_token                :string(255)
#  referring_id               :integer
#  story                      :text
#  post_story_to_wall         :boolean
#  npo_id                     :integer
#  completed_round_one_at     :datetime
#  emailed_invite_friends_at  :datetime
#  emailed_scores_unlocked_at :datetime
#

class User < ActiveRecord::Base
  serialize :location
  serialize :profile

  before_create :generate_givey_token

  belongs_to :referring_friend, :class_name => "User", :foreign_key => "referring_id"
  has_one :profile, :class_name => "Profile", :foreign_key => "uid", :primary_key => "uid", :dependent => :destroy
  has_many :donations
  belongs_to :npo

  has_many :friends, :dependent => :destroy  do
    def pick(n=3)
      randomized.limit(n)
    end

    def outdated?
      return active.maximum(:created_at) < 3.days.ago
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

    def next_available
      spark = undecided.first
      if spark && spark.friends.count < 2
        spark.destroy
        next_available
      else
        return spark
      end
    end
  end

  scope :scorable, lambda {
    joins("join profiles on profiles.uid = users.uid").
    where("coalesce(profiles.friend_list_count,0) >= #{Profile::MIN_FRIEND_LISTS_REQUIRED}").
    order("profiles.score DESC")
  }
  scope :not_scorable, lambda {
    joins("join profiles on profiles.uid = users.uid").
    where("coalesce(profiles.friend_list_count,0) < #{Profile::MIN_FRIEND_LISTS_REQUIRED}").
    order("profiles.score DESC")
  }
  scope :with_causes, where("npo_id is not null")
  scope :with_stories, where("npo_id is not null AND char_length(story) > 5")

  def admin?
    self.admin
  end
  
  def mturk?
    Mturk.find_by_uid(uid)
  end

  def first_name
    self.name.split(/\s/)[0]
  end

  def public_display_name
    last_initial = self.name.split(/\s/)[1][0]
    return "#{first_name} #{last_initial}."
  end
  
  def score
    profile.score
  end

  def has_a_cause?
    !self.npo_id.nil?
  end

  def self.random_with_a_cause
    self.with_causes.sort_by{rand}.first
  end

  def self.random_with_a_story
    self.with_stories.sort_by{rand}.first
  end

  def friends_scores_unlocked?
    self.sparks.decided.count+1 >= 10
  end

  def needs_friends?
    self.friends.active.count < 40
  end

  def waiting?
    self.sparks.decided.count+1 > 20
  end

  def scores_unlocked?
    self.waiting? && self.profile.scorable?
  end

  def prepare_sparks(num=25)
    questions = Question.pick(num-1)
    spark_friends = self.friends.pick(40).all

    question_ndx = 0
    friend_ndx = 0
    0.upto(num-1).each do |i|
      question_ndx = (question_ndx < questions.count ? question_ndx : 0)
      spark_friends += self.friends.pick(40).all if (friend_ndx+2) > spark_friends.count
      self.sparks.create(:question => questions[question_ndx], :friend_uid_1 => spark_friends[friend_ndx].uid, :friend_uid_2 => spark_friends[friend_ndx+1].uid, :friend_uid_3 => spark_friends[friend_ndx+2].uid)
      question_ndx += 1
      friend_ndx += 3
    end
  end

  def get_spark
    spark = sparks.next_available
    unless spark
      prepare_sparks   # => if there are no more undecided prepare a new set of sparks
      spark = sparks.next_available
    end
    spark
  end

  def referral_link
    return "http://#{APP_CONFIG[:domain]}/r/#{self.givey_token}"
  end

  def self.create_with_mini_fb(fb, location, referring_id)
    create! do |user|
      user.provider = 'facebook'
      user.uid = fb.id
      user.location = location
      user.referring_id = referring_id
      user.post_story_to_wall = true # set to true.  let them uncheck
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
    fb ||= MiniFB::OAuthSession.new(self.token)
    res = fb.multifql({:all_friends => all_friends_fql, :photos => photos_fql})
    friends = combine_friends_and_photos(res)
    save_friends(friends)
    return true
  end

  def destroy_and_get_friends
    self.friends.active.destroy_all
    self.get_friends
  end

  def post_to_wall(*args)
    begin
      options = extract_options!(args)
      fb = MiniFB::OAuthSession.new(self.token)
      fb.post('me', :type => :feed, :params => {
                :link => (options[:link] || self.referral_link),
                :name => (options[:name] || "Givey.org"),
                :caption => options[:caption],
                :description => options[:description],
                :message => options[:message]
      })
    rescue Exception => e
    end
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
            FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me() #{exclude_sql}) ORDER BY rand() LIMIT 60"
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
        profile = Profile.find(:first, :conditions => ['uid = ? AND updated_at > ?',f.uid.to_s, 1.day.ago])
        if profile
          profile.update_attributes(:details => f.details, :photos => f.photos)
          profile.update_friends_list_count!     # => updates profile table for the user with the latest count for scoring purposes
        else
          profile = Profile.create(:uid => f.uid, :details => f.details, :photos => f.photos, :friend_list_count => 1)
        end
      end
    end

end
