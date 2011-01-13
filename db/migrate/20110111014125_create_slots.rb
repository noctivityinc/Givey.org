class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.integer :campaign_id
      t.integer :user_id
      t.boolean :donated
      t.integer :npo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :slots
  end
end
