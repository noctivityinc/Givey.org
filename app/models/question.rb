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
  # attr_accessible :name, :value, :active, :phrase, :background

  has_many :sparks, :dependent => :destroy
  has_many :backgrounds, :dependent => :destroy do
    def pick
      self.active.sort_by{rand}.first
    end
  end
  validates_presence_of :name, :value, :phrase, :backgrounds
  validates_uniqueness_of :name

  scope :active, where(:active => true)

  accepts_nested_attributes_for :backgrounds, :allow_destroy => true

  def self.pick(n=5)
    active.sort_by{rand}[0..(n-1)]
  end

end
