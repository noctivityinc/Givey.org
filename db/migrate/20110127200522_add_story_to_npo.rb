class AddStoryToNpo < ActiveRecord::Migration
  def self.up
    add_column :npos, :story, :text
  end

  def self.down
    remove_column :npos, :story
  end
end
