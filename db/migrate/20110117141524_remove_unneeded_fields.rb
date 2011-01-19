class RemoveUnneededFields < ActiveRecord::Migration

  def self.up
    remove_column :campaigns, :slots_available
    remove_column :campaigns, :slot_value
    remove_column :campaigns, :video_guid
    remove_column :campaigns, :payment_completed_at
    remove_column :campaigns, :givey_tip
    remove_column :campaigns, :tip_amount
    add_column :campaigns, :current_pot_value, :integer
  end

  def self.down
    add_column :campaigns, :tip_amount, :integer
    add_column :campaigns, :givey_tip, :boolean
    remove_column :campaigns, :current_pot_value
    add_column :campaigns, :payment_completed_at, :datetime
    add_column :campaigns, :slot_value, :integer
  end
end
