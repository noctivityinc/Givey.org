class AddQuestionToBackgrounds < ActiveRecord::Migration
  def self.up
    add_column :backgrounds, :question_id, :integer
  end

  def self.down
    remove_column :backgrounds, :question_id
  end
end
