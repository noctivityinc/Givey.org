class AddGiveyTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :givey_token, :string
    add_column :users, :referring_id, :integer
  end

  def self.down
    remove_column :users, :referring_id
    remove_column :users, :givey_token
  end
end