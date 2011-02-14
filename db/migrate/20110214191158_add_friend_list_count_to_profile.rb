class AddFriendListCountToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :friend_list_count, :integer
    add_index :profiles, :friend_list_count
  end

  def self.down
    remove_index :profiles, :friend_list_count
    remove_column :profiles, :friend_list_count
  end
end