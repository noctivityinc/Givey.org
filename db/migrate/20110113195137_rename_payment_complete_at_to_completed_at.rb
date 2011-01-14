class RenamePaymentCompleteAtToCompletedAt < ActiveRecord::Migration
  def self.up
    rename_column :campaigns, :payment_complete_at, :payment_completed_at
  end

  def self.down
    rename_column :campaigns, :payment_completed_at, :payment_complete_at
  end
end