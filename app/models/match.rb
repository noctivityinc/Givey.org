# == Schema Information
#
# Table name: matches
#
#  id                :integer         not null, primary key
#  campaign_id       :integer
#  user_id           :integer
#  winner_uid        :string(255)
#  completed_at      :datetime
#  total_rounds      :integer
#  friends_hash      :text
#  previous_match_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Match < ActiveRecord::Base
  serialize :friends_hash
  
  belongs_to :user
  belongs_to :campaign
  has_many :duels, :dependent => :destroy  do 
    def winners_for_round(round)
      played.where(:round => round).map {|x| x.winner_uid}
    end
  end

  validates_presence_of :campaign_id, :user_id
  
  scope :incomplete, where('winner_uid IS NULL')
  scope :complete, where('winner_uid IS NOT NULL')
  
  def winner
    friends_hash[self.winner_uid]
  end
  
end
