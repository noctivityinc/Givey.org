class AddActiveToFriends < ActiveRecord::Migration
  def self.up
    add_column :friends, :active, :boolean, :default => true 
  end

  def self.down
    remove_column :friends, :active
  end
end
