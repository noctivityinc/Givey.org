# == Schema Information
#
# Table name: slots
#
#  id          :integer         not null, primary key
#  campaign_id :integer
#  user_id     :integer
#  donated     :boolean
#  npo_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Slot < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :user
  belongs_to :npo
end
