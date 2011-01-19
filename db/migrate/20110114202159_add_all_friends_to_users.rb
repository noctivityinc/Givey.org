class AddAllFriendsToUsers < ActiveRecord::Migration
  def self.up
    remove_column :campaigns, :all_friends
    add_column :users, :all_friends, :text
  end

  def self.down
    remove_column :users, :all_friends
  end
end
