# == Schema Information
#
# Table name: sparks
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  question_id  :integer
#  winner_uid   :string(255)
#  friend_uid_1 :string(255)
#  friend_uid_2 :string(255)
#  friend_uid_3 :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Spark < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validate :unique_for_friends
  
  scope :undecided, where(:winner_uid => nil)
  
  def friends
    (res ||= []) << Profile.find_by_uid(friend_uid_1)
    res << Profile.find_by_uid(friend_uid_2)
    res << Profile.find_by_uid(friend_uid_3) unless friend_uid_3.blank?
    return res
  end
  
  private
  
  def unique_for_friends
    sparks = user.sparks.where(:question_id => question_id)
    debugger
    spark_friends = sparks.inject([]) {|res,x| res << [x.friend_uid_1, x.friend_uid_2, x.friend_uid_3].sort} if sparks
    return !spark_friends.detect {|x| [self.friend_uid_1, self.friend_uid_2, self.friend_uid_3].sort == x}
  end
end
