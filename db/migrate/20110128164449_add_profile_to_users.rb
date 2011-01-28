class AddProfileToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :profile, :text
    remove_column :users, :all_friends
  end

  def self.down
    remove_column :users, :profile
  end
end
