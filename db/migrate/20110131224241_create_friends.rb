class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.integer :user_id
      t.string :uid

      t.timestamps
    end
    
    add_index :friends, :uid
    add_index :friends, [:user_id, :uid], :name => "ndx_user_id_and_uid"
  end

  def self.down
    remove_index :friends, :name => :ndx_user_id_and_uid
    remove_index :friends, :uid
    drop_table :friends
  end
end