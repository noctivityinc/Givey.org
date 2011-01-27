# == Schema Information
#
# Table name: challengers
#
#  id         :integer         not null, primary key
#  uid        :string(255)
#  duel_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Challenger < ActiveRecord::Base
  belongs_to :duel
end
