# == Schema Information
#
# Table name: beta_tests
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  access_count     :integer
#  last_accessed_at :datetime
#  feedback         :text
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class BetaTestsTest < ActiveSupport::TestCase
  should "be valid" do
    assert BetaTests.new.valid?
  end
end
