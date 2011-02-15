class AddGiveyTokenToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :givey_token, :string
    
    add_index :profiles, :givey_token
  end

  def self.down
    remove_index :profiles, :givey_token
    remove_column :profiles, :givey_token
  end
end