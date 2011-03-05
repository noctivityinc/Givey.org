# == Schema Information
#
# Table name: fb_errors
#
#  id         :integer         not null, primary key
#  code       :string(255)
#  message    :string(255)
#  user_id    :integer
#  user_agent :text
#  source     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FbError < ActiveRecord::Base
  attr_accessible :code, :message, :user_id, :user_agent, :source
  
  belongs_to :user
  
  def self.record(ex,source,user_agent=nil,user=nil)
    attributes = {:code => ex.code, :message => ex.message, :user_agent => user_agent, :source => source}
    attributes.merge!({:user_id => user.id}) if user
    res = self.create(attributes)
    ErrorMailer.facebook_error(res).deliver if res
  end
end
