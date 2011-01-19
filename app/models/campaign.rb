# == Schema Information
#
# Table name: campaigns
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  completed_at      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  current_pot_value :integer
#

class Campaign < ActiveRecord::Base
  belongs_to :user
  has_many :matches, :dependent => :destroy 

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

end
