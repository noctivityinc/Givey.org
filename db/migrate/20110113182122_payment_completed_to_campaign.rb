class PaymentCompletedToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :payment_complete_at, :datetime
  end

  def self.down
    remove_column :campaigns, :payment_complete_at
  end
end