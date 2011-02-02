# == Schema Information
#
# Table name: battles
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

class Battle < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
end
