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
  scope :decided, where('winner_uid IS NOT NULL')
  scope :order_by_latest, :order => "updated_at desc"
  
  def friends
    (res ||= []) << user.friends.active.find_by_uid(friend_uid_1).profile rescue nil
    (res ||= []) << user.friends.active.find_by_uid(friend_uid_2).profile rescue nil
    (res ||= []) << user.friends.active.find_by_uid(friend_uid_3).profile rescue nil unless friend_uid_3.blank?
    return res
  end

  def selected
    Profile.find_by_uid(winner_uid)
  end

  def not_selected
    (res ||= []) << friend_uid_1 << friend_uid_2 << friend_uid_3
    res.delete(winner_uid)
    return res.map {|x| Profile.find_by_uid(x)}
  end

  def validate
    if friends.empty?
      destroy
    end
  end

  def replace_friend(uid)
    friend = user.friends.find_by_uid(uid)
    if friend
      friend.update_attributes(:active => false)
      new_friend_uid = user.friends.pick(1).first.uid
      self.update_attribute(:friend_uid_1, new_friend_uid) if self.friend_uid_1 == uid
      self.update_attribute(:friend_uid_2, new_friend_uid) if self.friend_uid_2 == uid
      self.update_attribute(:friend_uid_3, new_friend_uid) if self.friend_uid_3 == uid
    end
  end
  
  def update_winner!(uid)
    self.update_attribute(:winner_uid, uid)
    selected.update_score!(self.question.value)
  end

  private

    def unique_for_friends
      sparks = user.sparks.where(:question_id => question_id)
      spark_friends = sparks.inject([]) {|res,x| res << [x.friend_uid_1, x.friend_uid_2, x.friend_uid_3].sort} if sparks
      return !spark_friends.detect {|x| [self.friend_uid_1, self.friend_uid_2, self.friend_uid_3].sort == x}
    end
end
