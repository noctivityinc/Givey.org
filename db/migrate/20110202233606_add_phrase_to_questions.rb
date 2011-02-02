class AddPhraseToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :phrase, :string
    remove_column :questions, :story
  end

  def self.down
    add_column :questions, :story, :text
    remove_column :questions, :phrase
  end
end
