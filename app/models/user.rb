# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  provider    :string(255)
#  uid         :string(255)
#  email       :string(255)
#  name        :string(255)
#  gender      :string(255)
#  locale      :string(255)
#  profile_pic :string(255)
#  token       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  first_name  :string(255)
#  last_name   :string(255)
#  admin       :boolean
#  all_friends :text
#

class User < ActiveRecord::Base
  serialize :all_friends
  
  has_many :campaigns, :dependent => :destroy 
  has_many :matches
  
  def admin?
    self.admin
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
    end
  end

  def self.create_with_mini_fb(fb)
    create! do |user|
      user.provider = 'facebook'
      user.uid = fb.id
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

  def update_with_mini_fb(fb,profile_pic,access_token)
    self.first_name = fb.first_name
    self.last_name = fb.last_name
    self.name = fb.name
    self.email = fb.email rescue nil
    self.gender = fb.gender rescue nil
    self.locale = fb.locale rescue nil
    self.profile_pic = profile_pic rescue nil
    self.token = access_token
    save!
  end
  
  def log_out!
    self.token = nil
    save!
  end
end
