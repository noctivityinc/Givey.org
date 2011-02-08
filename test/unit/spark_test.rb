# == Schema Information
#
# Table name: sparks
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  question_id  :integer
#  winner_uid   :string(255)
#  friend_uid_1 :string(255)
#  friend_uid_2 :string(255)
#  friend_uid_3 :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class SparkTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Spark.new.valid?
  end
end
