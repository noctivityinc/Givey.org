# == Schema Information
#
# Table name: friends
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean         default(TRUE)
#

require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
