class ModifyDonations < ActiveRecord::Migration
  def self.up
    remove_column :donations, :wepay_id
    remove_column :donations, :event
    rename_column :donations, :amount, :net
    add_column :donations, :bill_id, :integer
    add_column :donations, :response, :text
    add_column :donations, :fee, :decimal, :precision => 8, :scale => 2  
  end

  def self.down
    rename_column :donations, :net, :amount
    add_column :donations, :event, :string
    remove_column :donations, :fee
    remove_column :donations, :response
    remove_column :donations, :bill_id
    add_column :donations, :wepay_id, :string
  end
end