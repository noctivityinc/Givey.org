# == Schema Information
#
# Table name: challengers
#
#  id         :integer         not null, primary key
#  uid        :string(255)
#  duel_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ChallengerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
