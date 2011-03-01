# == Schema Information
#
# Table name: friends
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean         default(TRUE)
#

class Friend < ActiveRecord::Base

  after_destroy :remove_sparks!

  belongs_to :user
  has_one :profile, :class_name => "Profile", :foreign_key => "uid", :primary_key => "uid"

  scope :active, where(:active => true)
  scope :random, lambda {|x| order("random()").limit(x)}
  scope :except, lambda {|uid| where("uid != '#{uid}'")}
  scope :randomized, :order => "random()" 

  scope :scorable, lambda {
    joins("join profiles on profiles.uid = friends.uid").
    where("profiles.friend_list_count >= #{Profile::MIN_FRIEND_LISTS_REQUIRED}").
    order("profiles.score DESC")
  }
  scope :not_scorable, lambda {
    joins("join profiles on profiles.uid = friends.uid").
    where("profiles.friend_list_count < #{Profile::MIN_FRIEND_LISTS_REQUIRED}")
  }

  def user?
    User.find_by_uid(self.uid)
  end

  private

    def remove_sparks!
      Spark.delete_all("(friend_uid_1 = '#{uid}' OR friend_uid_2 = '#{uid}' OR friend_uid_3 = '#{uid}') AND user_id = #{user_id}")
    end

end
