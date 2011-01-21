class AddSharedOnFacebookAndSharedWithWinnerToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :shared_on_facebook, :boolean
    add_column :games, :shared_with_winner, :boolean
  end

  def self.down
    remove_column :games, :shared_with_winner
    remove_column :games, :shared_on_facebook
  end
end
