class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.string :winner_uid
      t.datetime :completed_at
      t.integer :total_rounds
      t.text :friends_hash
      t.integer :previous_match_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
