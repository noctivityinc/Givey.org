class AddFriendsHashToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :friends_hash, :text
  end

  def self.down
    remove_column :campaigns, :friends_hash
  end
end
