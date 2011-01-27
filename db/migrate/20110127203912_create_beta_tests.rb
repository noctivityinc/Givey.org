class CreateBetaTests < ActiveRecord::Migration
  def self.up
    create_table :beta_tests do |t|
      t.string :email
      t.integer :access_count
      t.datetime :last_accessed_at
      t.text :feedback
      t.timestamps
    end
  end

  def self.down
    drop_table :beta_tests
  end
end
