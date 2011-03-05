# == Schema Information
#
# Table name: fb_errors
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  message    :string(255)
#  user_id    :integer
#  user_agent :text
#  source     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class FbErrorTest < ActiveSupport::TestCase
  should "be valid" do
    assert FbError.new.valid?
  end
end
