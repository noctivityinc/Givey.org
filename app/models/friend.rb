# == Schema Information
#
# Table name: friends
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean         default(TRUE)
#

class Friend < ActiveRecord::Base

  after_destroy :remove_sparks!
  
  belongs_to :user
  has_one :profile, :class_name => "Profile", :foreign_key => "uid", :primary_key => "uid"
  
  scope :active, where(:active => true)
  scope :random, lambda {|x| order("random()").limit(x)}
  
  private
  
  def remove_sparks!
    Spark.delete_all("(friend_uid_1 = '#{uid}' OR friend_uid_2 = '#{uid}' OR friend_uid_3 = '#{uid}') AND user_id = #{user_id}")
  end
  
end
