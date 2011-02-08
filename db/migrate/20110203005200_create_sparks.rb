class CreateSparks < ActiveRecord::Migration
  def self.up
    create_table :sparks do |t|
      t.integer :user_id
      t.integer :question_id
      t.string :winner_uid
      t.string :friend_uid_1
      t.string :friend_uid_2
      t.string :friend_uid_3
      t.timestamps
    end
  end

  def self.down
    drop_table :sparks
  end
end
