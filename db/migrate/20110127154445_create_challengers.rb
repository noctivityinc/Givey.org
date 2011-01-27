class CreateChallengers < ActiveRecord::Migration
  def self.up
    create_table :challengers do |t|
      t.string :uid
      t.integer :duel_id

      t.timestamps
    end
    
    remove_column :duels, :challenger_uids
    
    add_index :challengers, :uid
    add_index :challengers, [:uid, :duel_id], :name => "indx_duel_uid"
  end

  def self.down
    remove_index :challengers, :name => :indx_duel_uid
    remove_index :challengers, :uid
    drop_table :challengers
  end
end