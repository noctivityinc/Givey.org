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
#  first_name                   :string(255)
#  last_name                    :string(255)
#  admin                        :boolean
#  location                     :text
#  givey_token                  :string(255)
#  referring_id                 :integer
#  candidate                    :boolean
#  candidates_story             :text
#  candidate_post_story_to_wall :boolean
#  profile                      :text
#

class User < ActiveRecord::Base
  serialize :location
  serialize :profile

  before_create :generate_givey_token
  
  has_many :friends do
    def pick(n=3)
      self.sort_by{rand}[0..(n-1)]
    end
  end
  
  has_one :profile, :class_name => "Profile", :foreign_key => "uid", :primary_key => "uid" 
  has_many :battles 
  belongs_to :referring_friend, :class_name => "User", :foreign_key => "referring_id"

  def admin?
    self.admin
  end
  
  def prepare_a_battle
    question = Question.active.sort_by{rand}.first
    battle_friends = self.friends.pick
    return self.battles.create!(:question => question, :friend_uid_1 => battle_friends[0].uid, :friend_uid_2 => battle_friends[1].uid, :friend_uid_3 => battle_friends[2].uid)
  end

  def referral_link
    return "http://#{APP_CONFIG[:domain]}/#{self.givey_token}"
  end

  def self.create_with_omniauth(auth, location, referring_id)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.location = location
      user.referring_id = referring_id
    end
  end

  def self.create_with_mini_fb(fb, location, referring_id)
    create! do |user|
      user.provider = 'facebook'
      user.uid = fb.id
      user.location = location
      user.referring_id = referring_id
    end
  end

  def update_with_omniauth(auth)
    self.first_name = auth["user_info"]["first_name"]
    self.last_name = auth["user_info"]["last_name"]
    self.name = auth["user_info"]["name"]
    self.email = auth["extra"]["user_hash"]["email"] rescue nil
    self.gender = auth["extra"]["user_hash"]["gender"] rescue nil
    self.locale = auth["extra"]["user_hash"]["locale"] rescue nil
    self.token = auth["credentials"]["token"]
    save!
  end

  def update_with_mini_fb(profile,access_token)
    self.first_name = profile.first_name
    self.last_name = profile.last_name
    self.name = profile.name
    self.email = profile.email rescue nil
    self.gender = profile.sex rescue nil
    self.locale = profile.locale rescue nil
    # self.profile = profile rescue nil
    self.profile_pic = profile.pic_square rescue nil
    self.token = access_token
    save!
  end

  def log_out!
    # self.token = nil
    # save!
  end

  private

    def generate_givey_token
      self.givey_token = rand(36**8).to_s(36)
    end


end
