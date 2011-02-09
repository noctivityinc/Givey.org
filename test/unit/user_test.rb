# == Schema Information
#
# Table name: users
#
#  id                           :integer         not null, primary key
#  provider                     :string(255)
#  uid                          :string(255)
#  email                        :string(255)
#  name                         :string(255)
#  gender                       :string(255)
#  locale                       :string(255)
#  profile_pic                  :string(255)
#  token                        :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  admin                        :boolean
#  location                     :text
#  givey_token                  :string(255)
#  referring_id                 :integer
#  candidate                    :boolean
#  candidates_story             :text
#  candidate_post_story_to_wall :boolean
#  profile                      :text
#  candidates_npo_id            :integer
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
