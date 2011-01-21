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

require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Donation.new.valid?
  end
end
