# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  email      :string(255)
#  name       :string(255)
#  gender     :string(255)
#  locale     :string(255)
#  avatar_url :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  first_name :string(255)
#  last_name  :string(255)
#

class User < ActiveRecord::Base
  has_many :campaigns
  has_many :slots

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
    end
  end
  
  def update_with_omniauth(auth)
    self.first_name = auth["user_info"]["first_name"]
    self.last_name = auth["user_info"]["last_name"]
    self.name = auth["user_info"]["name"]
    self.email = auth["extra"]["user_hash"]["email"]
    self.gender = auth["extra"]["user_hash"]["gender"]
    self.locale = auth["extra"]["user_hash"]["locale"]
    self.token = auth["credentials"]["token"]
    save!
  end
end
