class CreateDuels < ActiveRecord::Migration
  def self.up
    create_table :duels do |t|
      t.text :challenger_ids
      t.integer :round
      t.string :winner_id
      t.integer :campaign_id

      t.timestamps
    end
  end

  def self.down
    drop_table :duels
  end
end
