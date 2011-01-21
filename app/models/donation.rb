# == Schema Information
#
# Table name: donations
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  game_id        :integer
#  amount         :decimal(, )
#  donated_at     :datetime
#  wepay_id       :string(255)
#  transaction_id :string(255)
#  event          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Donation < ActiveRecord::Base
    attr_accessible :user_id, :game_id, :amount, :donated_at, :wepay_id, :transaction_id, :event
end
