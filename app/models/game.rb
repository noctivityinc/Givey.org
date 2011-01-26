# == Schema Information
#
# Table name: games
#
#  id                 :integer         not null, primary key
#  campaign_id        :integer
#  user_id            :integer
#  winner_uid         :string(255)
#  completed_at       :datetime
#  friends_hash       :text
#  created_at         :datetime
#  updated_at         :datetime
#  token              :string(255)
#  referring_game_id  :integer
#  official           :boolean         default(TRUE)
#  shared_on_facebook :boolean
#  shared_with_winner :boolean
#  total_candidates   :integer
#  posted_to_wall     :boolean
#  notified_winner    :boolean
#

class Game < ActiveRecord::Base
  serialize :friends_hash
  before_create :generate_token

  belongs_to :user

  has_many :duels, :dependent => :destroy  do
    def winners_for_round(round)
      played.where(:round => round).map {|x| x.winner_uid}
    end

    def replace_sub
      a_sub = subs.first
      if a_sub
        a_sub.is_sub = false
        a_sub.save!
      end
    end
  end

  validates_presence_of :user_id

  scope :incomplete, where('winner_uid IS NULL')
  scope :complete, where('winner_uid IS NOT NULL')
  scope :official, where(:official => true)

  def winner
    friends_hash[self.winner_uid]
  end
  
  private
  
  def generate_token
    self.token = rand(36**8).to_s(36)
  end
  

end
