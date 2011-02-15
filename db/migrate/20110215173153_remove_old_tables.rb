class RemoveOldTables < ActiveRecord::Migration
  def self.up
    begin
      drop_table :games
      drop_table :battles
      drop_table :duels
      drop_table :payment_notifications
    rescue Exception => e
      
    end
  end

  def self.down
  end
end
