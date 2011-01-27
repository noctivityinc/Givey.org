class CreateBetaTesters < ActiveRecord::Migration
  def self.up
    create_table :beta_testers do |t|
      t.string :email
      t.integer :access_count
      t.datetime :last_accessed_at
      t.text :feedback
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :beta_testers
  end
end
