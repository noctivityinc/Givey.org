class AddGiveyTipToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :givey_tip, :boolean
    add_column :campaigns, :tip_amount, :integer
  end

  def self.down
    remove_column :campaigns, :tip_amount
    remove_column :campaigns, :givey_tip
  end
end
