# == Schema Information
#
# Table name: beta_testers
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  access_count     :integer
#  last_accessed_at :datetime
#  feedback         :text
#  active           :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class BetaTesterTest < ActiveSupport::TestCase
  should "be valid" do
    assert BetaTester.new.valid?
  end
end
