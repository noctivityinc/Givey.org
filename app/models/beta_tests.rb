# == Schema Information
#
# Table name: beta_tests
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  access_count     :integer
#  last_accessed_at :datetime
#  feedback         :text
#  created_at       :datetime
#  updated_at       :datetime
#

class BetaTests < ActiveRecord::Base
end
