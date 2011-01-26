class AddCandidatesStoryToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :candidates_story, :text
    add_column :users, :candidate_post_story_to_wall, :boolean
  end

  def self.down
    remove_column :users, :candidate_post_story_to_wall
    remove_column :users, :candidates_story
  end
end