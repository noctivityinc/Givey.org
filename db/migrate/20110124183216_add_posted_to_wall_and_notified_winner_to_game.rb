class AddPostedToWallAndNotifiedWinnerToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :posted_to_wall, :boolean
    add_column :games, :notified_winner, :boolean
  end

  def self.down
    remove_column :games, :notified_winner
    remove_column :games, :posted_to_wall
  end
end
