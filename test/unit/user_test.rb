# == Schema Information
#
# Table name: users
#
#  id                         :integer         not null, primary key
#  provider                   :string(255)
#  uid                        :string(255)
#  email                      :string(255)
#  name                       :string(255)
#  gender                     :string(255)
#  locale                     :string(255)
#  token                      :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  admin                      :boolean
#  location                   :text
#  givey_token                :string(255)
#  referring_id               :integer
#  story                      :text
#  post_story_to_wall         :boolean
#  npo_id                     :integer
#  completed_round_one_at     :datetime
#  emailed_invite_friends_at  :datetime
#  emailed_scores_unlocked_at :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
