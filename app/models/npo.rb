# == Schema Information
#
# Table name: npos
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  website      :string(255)
#  email        :string(255)
#  description  :text
#  category_id  :integer
#  feature      :boolean
#  num_featured :integer
#  active       :boolean
#  summary      :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Npo < ActiveRecord::Base
  attr_accessible :name, :website, :email, :description, :category_id, :feature, :num_featured, :active, :summary
  has_many :slots
  has_many :campaigns, :through => :slots
  
   
end
