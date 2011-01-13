class AddPpEmailToNpos < ActiveRecord::Migration
  def self.up
    add_column :npos, :paypal_email, :string
    add_column :npos, :tax_id, :string
  end

  def self.down
    remove_column :npos, :tax_id
    remove_column :npos, :paypal_email
  end
end