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

require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
