# == Schema Information
#
# Table name: campaigns
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  slots_available :integer
#  slot_value      :integer
#  video_guid      :string(255)
#  completed_at    :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Campaign < ActiveRecord::Base
  attr_accessible :user_id, :slots_available, :slot_value, :video_guid, :completed_at
  
  has_many :slots
  belongs_to :user
end
