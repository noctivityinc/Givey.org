# == Schema Information
#
# Table name: mturks
#
#  id                 :integer         not null, primary key
#  uid                :string(255)
#  confirmation_token :string(255)
#  completed_at       :datetime
#  approved_at        :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class Mturk < ActiveRecord::Base
  before_create :generate_confirmation_token
  
  validates_presence_of :uid
  
  private

    def generate_confirmation_token
      self.confirmation_token = rand(36**8).to_s(36)
    end

end
