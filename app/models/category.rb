# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  active     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  attr_accessible :name, :active
  
  has_many :npos
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  scope :active, where("active = ?", true)
  
end
