# == Schema Information
#
# Table name: duels
#
#  id              :integer         not null, primary key
#  challenger_uids :text
#  round           :integer
#  winner_uid      :string(255)
#  match_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class DuelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
