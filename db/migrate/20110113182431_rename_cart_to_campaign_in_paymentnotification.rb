class RenameCartToCampaignInPaymentnotification < ActiveRecord::Migration
  def self.up
    rename_column :payment_notifications, :cart_id, :campaign_id
  end

  def self.down
    rename_column :payment_notifications, :campaign_id, :cart_id
  end
end