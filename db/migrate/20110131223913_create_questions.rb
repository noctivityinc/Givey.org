class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :name
      t.integer :value
      t.boolean :active
      t.text :story
      t.timestamps
    end
    
  end

  def self.down
    remove_index :questions, :column_name
    drop_table :questions
  end
end