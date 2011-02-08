# == Schema Information
#
# Table name: friends
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Friend < ActiveRecord::Base
  
  belongs_to :user
  has_one :profile, :class_name => "Profile", :foreign_key => "uid", :primary_key => "uid"
  
  
end
