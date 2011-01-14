# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  active     :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  should "be valid" do
    assert Category.new.valid?
  end
end
