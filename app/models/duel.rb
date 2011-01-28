# == Schema Information
#
# Table name: duels
#
#  id         :integer         not null, primary key
#  round      :integer
#  winner_uid :string(255)
#  game_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  is_sub     :boolean
#  active     :boolean
#

class Duel < ActiveRecord::Base
  DUEL_SIZES = [[36, 19],[30, 18], [24, 19], [20, 18], [18, 13], [16, 15], [12, 7], [10, 8], [9,4], [8,7], [6,3], [4,3], [3,1], [2,1]]
  attr_accessor :challenger_uids
  after_create :create_challengers
  
  belongs_to :game
  has_many :challengers, :dependent => :destroy
  
  default_scope where(:active => true)
  scope :subs, where(:is_sub => true)
  scope :players, where("is_sub IS NULL OR is_sub = false")
  scope :unplayed, lambda {players.where(:winner_uid => nil)}
  scope :played, where("winner_uid IS NOT NULL")
  scope :inactive, where("active IS NULL OR active = false")
  
  private
  
  def create_challengers
    self.challenger_uids.each do |uid|
      self.challengers.create!(:uid => uid)
    end
  end
end
