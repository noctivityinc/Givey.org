class AddScoreToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :score, :integer
    
    add_index :profiles, :score
    add_index :profiles, [:friend_list_count, :score], :name => "index_list_count_score"
  end

  def self.down
    remove_index :profiles, :name => :index_list_count_score
    remove_index :profiles, :score
    remove_column :profiles, :score
  end
end