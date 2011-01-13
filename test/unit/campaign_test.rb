# == Schema Information
#
# Table name: campaigns
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  slots_available :integer
#  slot_value      :integer
#  video_guid      :string(255)
#  completed_at    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  should "be valid" do
    assert Campaign.new.valid?
  end
end
