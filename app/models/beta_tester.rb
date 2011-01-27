# == Schema Information
#
# Table name: beta_testers
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  access_count     :integer
#  last_accessed_at :datetime
#  feedback         :text
#  active           :boolean
#  created_at       :datetime
#  updated_at       :datetime
#

class BetaTester < ActiveRecord::Base
    attr_accessible :email, :active, :feedback
end
