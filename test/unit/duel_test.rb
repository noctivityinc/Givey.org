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

require 'test_helper'

class DuelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
