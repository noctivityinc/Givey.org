require 'test_helper'

class BetaTesterTest < ActiveSupport::TestCase
  should "be valid" do
    assert BetaTester.new.valid?
  end
end
