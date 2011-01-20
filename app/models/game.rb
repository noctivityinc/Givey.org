# == Schema Information
#
# Table name: games
#
#  id                :integer         not null, primary key
#  campaign_id       :integer
#  user_id           :integer
#  winner_uid        :string(255)
#  completed_at      :datetime
#  friends_hash      :text
#  created_at        :datetime
#  updated_at        :datetime
#  token             :string(255)
#  referring_game_id :integer
#  official          :boolean         default(TRUE)
#

class Game < ActiveRecord::Base
  serialize :friends_hash
  
  belongs_to :user

  has_many :duels, :dependent => :destroy  do 
    def winners_for_round(round)
      played.where(:round => round).map {|x| x.winner_uid}
    end
  end

  validates_presence_of :user_id
  
  scope :incomplete, where('winner_uid IS NULL')
  scope :complete, where('winner_uid IS NOT NULL')
  scope :official, where(:official => true)
  
  def winner
    friends_hash[self.winner_uid]
  end
  
end