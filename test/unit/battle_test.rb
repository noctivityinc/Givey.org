# == Schema Information
#
# Table name: battles
#
#  id           :integer         not null, primary key
#  question_id  :integer
#  winner_uid   :string(255)
#  friend_uid_1 :string(255)
#  friend_uid_2 :string(255)
#  friend_uid_3 :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class BattleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
