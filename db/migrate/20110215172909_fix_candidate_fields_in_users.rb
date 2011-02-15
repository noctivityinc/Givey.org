class FixCandidateFieldsInUsers < ActiveRecord::Migration
  #  candidate                    :boolean
  #  candidates_story             :text
  #  candidate_post_story_to_wall :boolean
  #  candidates_npo_id            :integer

  def self.up
    remove_column :users, :candidate
    rename_column :users, :candidates_story, :story
    rename_column :users, :candidate_post_story_to_wall, :post_story_to_wall
    rename_column :users, :candidates_npo_id, :npo_id
  end

  def self.down
    rename_column :users, :npo_id, :candidate_npo_id
    rename_column :users, :post_story_to_wall, :candidate_post_story_to_wall
    rename_column :users, :story, :candidates_story
    add_column :users, :candidate, :boolean
  end
end