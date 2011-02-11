# == Schema Information
#
# Table name: donations
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  net            :decimal(8, 2)
#  donated_at     :datetime
#  transaction_id :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  bill_id        :integer
#  response       :text
#  fee            :decimal(8, 2)
#

class Donation < ActiveRecord::Base
  serialize :response

  after_save :update_user

  belongs_to :user
  validates_presence_of :user

  scope :random, lambda {|x| order("random()").limit(x)}

  def self.total
    sum(:net) + sum(:fee)
  end
  
  def amount
    net + fee
  end

  def self.verify_and_create(current_user, transaction_id)
    return false if transaction_id.blank?

    wp = Wepay.new
    details = wp.get('/transaction/'+transaction_id.to_s)
    if details
      donation = current_user.donations.new()
      donation.response = details
      donation.net = details.result.net
      donation.fee = details.result.fee
      donation.transaction_id = transaction_id
      return donation.save
    end
  end

  private
  
  def update_user
    user.update_attribute(:candidate, true)
  end
end
