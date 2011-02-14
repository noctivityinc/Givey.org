# == Schema Information
#
# Table name: profiles
#
#  id                :integer         not null, primary key
#  uid               :string(255)
#  details           :text
#  photos            :text
#  created_at        :datetime
#  updated_at        :datetime
#  friend_list_count :integer
#

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
