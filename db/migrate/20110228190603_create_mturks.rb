class CreateMturks < ActiveRecord::Migration
  def self.up
    create_table :mturks do |t|
      t.string :uid
      t.string :confirmation_token
      t.datetime :completed_at
      t.datetime :approved_at
      t.timestamps
    end
  end

  def self.down
    drop_table :mturks
  end
end
