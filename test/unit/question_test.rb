# == Schema Information
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  value      :integer
#  active     :boolean
#  story      :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  should "be valid" do
    assert Question.new.valid?
  end
end
