class RemoveOldFields < ActiveRecord::Migration
  def self.up
    remove_column :donations, :game_id
    change_column :donations, :amount, :decimal, :precision => 8, :scale  => 2
    remove_column :users, :profile
    remove_column :users, :profile_pic
  end

  def self.down
    change_column :donations, :amount, :string
    add_column :users, :profile_pic, :string
    add_column :users, :profile, :text
    add_column :donations, :game_id, :integer
  end
end