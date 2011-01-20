# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  provider    :string(255)
#  uid         :string(255)
#  email       :string(255)
#  name        :string(255)
#  gender      :string(255)
#  locale      :string(255)
#  profile_pic :string(255)
#  token       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  first_name  :string(255)
#  last_name   :string(255)
#  admin       :boolean
#  all_friends :text
#  location    :text
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
