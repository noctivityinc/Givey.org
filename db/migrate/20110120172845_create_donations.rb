class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.integer :user_id
      t.integer :game_id
      t.decimal :amount
      t.datetime :donated_at
      t.string :wepay_id
      t.string :transaction_id
      t.string :event
      t.timestamps
    end
  end

  def self.down
    drop_table :donations
  end
end
