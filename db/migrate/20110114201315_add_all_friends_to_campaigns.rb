class AddAllFriendsToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :all_friends, :text
  end

  def self.down
    remove_column :campaigns, :all_friends
  end
end
