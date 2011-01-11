# == Schema Information
#
# Table name: slots
#
#  id          :integer         not null, primary key
#  campaign_id :integer
#  user_id     :integer
#  donated     :boolean
#  npo_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class SlotTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
