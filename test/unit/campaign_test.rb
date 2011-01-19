# == Schema Information
#
# Table name: campaigns
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  completed_at      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  current_pot_value :integer
#

require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  should "be valid" do
    assert Campaign.new.valid?
  end
end
