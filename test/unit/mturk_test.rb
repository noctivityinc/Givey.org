# == Schema Information
#
# Table name: mturks
#
#  id                 :integer         not null, primary key
#  uid                :string(255)
#  confirmation_token :string(255)
#  completed_at       :datetime
#  approved_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class MturkTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Mturk.new.valid?
  end
end
