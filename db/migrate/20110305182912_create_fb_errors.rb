class CreateFbErrors < ActiveRecord::Migration
  def self.up
    create_table :fb_errors do |t|
      t.string :code
      t.string :message
      t.integer :user_id
      t.text :user_agent
      t.string :source
      t.timestamps
    end
  end

  def self.down
    drop_table :fb_errors
  end
end
