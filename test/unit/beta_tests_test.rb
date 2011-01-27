require 'test_helper'

class BetaTestsTest < ActiveSupport::TestCase
  should "be valid" do
    assert BetaTests.new.valid?
  end
end
