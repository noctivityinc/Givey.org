# == Schema Information
#
# Table name: donations
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  net            :decimal(8, 2)
#  donated_at     :datetime
#  transaction_id :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  bill_id        :integer
#  response       :text
#  fee            :decimal(8, 2)
#

require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  should "be valid" do
    assert Donation.new.valid?
  end
end
