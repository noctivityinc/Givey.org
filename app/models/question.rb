# == Schema Information
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  value      :integer
#  active     :boolean
#  created_at :datetime
#  updated_at :datetime
#  phrase     :string(255)
#

class Question < ActiveRecord::Base
    attr_accessible :name, :value, :active, :phrase
    
    has_many :sparks
    validates_presence_of :name, :value, :phrase
    validates_uniqueness_of :name
    
    scope :active, where(:active => true)
end
