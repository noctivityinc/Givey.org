# == Schema Information
#
# Table name: payment_notifications
#
#  id             :integer         not null, primary key
#  params         :text
#  status         :string(255)
#  transaction_id :string(255)
#  campaign_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class PaymentNotificationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
