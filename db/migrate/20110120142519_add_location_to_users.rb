class AddLocationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :text
  end

  def self.down
    remove_column :users, :location
  end
end
