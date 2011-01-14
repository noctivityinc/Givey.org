# == Schema Information
#
# Table name: campaigns
#
#  id                   :integer         not null, primary key
#  user_id              :integer
#  slots_available      :integer
#  slot_value           :integer
#  video_guid           :string(255)
#  completed_at         :integer
#  created_at           :datetime
#  updated_at           :datetime
#  givey_tip            :boolean
#  tip_amount           :integer
#  payment_completed_at :datetime
#  friends_hash         :text
#

class Campaign < ActiveRecord::Base
  before_save :set_tip_amount
  serialize :friends_hash

  has_many :slots
  belongs_to :user

  def paypal_encrypted(return_url, notify_url, cancel_return_url)
    values = {
      :business => APP_CONFIG[:paypal]['email'],
      :cmd => '_xclick',
      :return => return_url,
      :invoice => id,
      :notify_url => notify_url,
      :cancel_return => cancel_return_url,
      :item_name => "#{user.name}'s Givey Campaign",
      :amount => donation_amount,
      :undefined_quantity  => 0,
      :no_shipping => 1,
      :no_note => 1,
      :cert_id => APP_CONFIG[:paypal]['cert_id']
    }
    Paypal.encrypt(values)
  end

  def set_tip_amount
    self.tip_amount = self.slot_value if self.givey_tip
  end

  def slot_total
    (slots_available*slot_value).to_f
  end

  def tip
    givey_tip ? tip_amount.to_f : 0.00
  end

  def donation_amount
    return slot_total + tip
  end
end
