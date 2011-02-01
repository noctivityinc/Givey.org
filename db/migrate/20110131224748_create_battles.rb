class CreateBattles < ActiveRecord::Migration
  def self.up
    create_table :battles do |t|
      t.integer :user_id
      t.integer :question_id
      t.string :winner_uid
      t.string :friend_uid_1
      t.string :friend_uid_2
      t.string :friend_uid_3

      t.timestamps
    end
    
    add_index :battles, :user_id
  end

  def self.down
    remove_index :battles, :user_id
    drop_table :battles
  end
end