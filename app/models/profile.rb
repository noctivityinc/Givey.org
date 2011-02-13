# == Schema Information
#
# Table name: profiles
#
#  id         :integer         not null, primary key
#  uid        :string(255)
#  details    :text
#  photos     :text
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base
  serialize :details
  serialize :photos
  
end
