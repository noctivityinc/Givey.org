class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :uid
      t.text :details
      t.text :photos

      t.timestamps
    end
    
    add_index :profiles, :uid
  end

  def self.down
    remove_index :profiles, :uid
    drop_table :profiles
  end
end