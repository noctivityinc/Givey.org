class CreateBackgrounds < ActiveRecord::Migration
  def self.up
    create_table :backgrounds do |t|
      t.boolean :active, :default => true  
      t.timestamps
    end
  end

  def self.down
    drop_table :backgrounds
  end
end
