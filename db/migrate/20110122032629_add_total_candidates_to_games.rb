class AddTotalCandidatesToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :total_candidates, :integer
  end

  def self.down
    remove_column :games, :total_candidates
  end
end
