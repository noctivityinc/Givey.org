# == Schema Information
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  value      :integer
#  active     :boolean
#  story      :text
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base
    attr_accessible :name, :value, :active, :story
    
    has_many :battles
    validates_presence_of :name, :value
    validates_uniqueness_of :name
    
    scope :active, where(:active => true)
end
