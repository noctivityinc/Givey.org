class GameCreation < ActiveRecord::Migration
  def self.up
    drop_table :campaigns
    rename_table :matches, :games
    rename_column :duels, :match_id, :game_id
    drop_table :participants
    add_column :games, :token, :string
    add_column :games, :referring_game_id, :integer
    remove_column :games, :previous_match_id
    remove_column :games, :total_rounds
    add_column :games, :official, :boolean, {:default => true}
  end

  def self.down
    remove_column :games, :official
    remove_column :games, :referring_game_id
    remove_column :games, :token
    rename_column :dules, :game_id
    rename_table :games, :matches
  end
end