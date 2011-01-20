# == Schema Information
#
# Table name: duels
#
#  id              :integer         not null, primary key
#  challenger_uids :text
#  round           :integer
#  winner_uid      :string(255)
#  game_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Duel < ActiveRecord::Base
  DUEL_SIZES = [[36, 19],[30, 18], [24, 19], [20, 18], [18, 13], [16, 15], [12, 7], [10, 8], [9,4], [8,7], [6,3], [4,3], [3,1], [2,1]]
  serialize :challenger_uids
  belongs_to :game
  
  scope :unplayed, where(:winner_uid => nil)
  scope :played, where("winner_uid IS NOT NULL")
end
