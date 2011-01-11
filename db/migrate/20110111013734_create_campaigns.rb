class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.integer :user_id
      t.integer :slots_available
      t.integer :slot_value
      t.string :video_guid
      t.integer :completed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :campaigns
  end
end
