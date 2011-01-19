# == Schema Information
#
# Table name: duels
#
#  id              :integer         not null, primary key
#  challenger_uids :text
#  round           :integer
#  winner_uid      :string(255)
#  match_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Duel < ActiveRecord::Base
  serialize :challenger_uids
  belongs_to :match
  
  scope :unplayed, where(:winner_uid => nil)
  scope :played, where("winner_uid IS NOT NULL")
  
end
