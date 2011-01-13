class AddAddressToNpos < ActiveRecord::Migration
  def self.up
    add_column :npos, :address_1, :string
    add_column :npos, :address_2, :string
    add_column :npos, :city, :string
    add_column :npos, :state, :string
    add_column :npos, :zip_code, :string
    add_column :npos, :attention, :string
    add_column :npos, :twitter_name, :string
    add_column :npos, :facebook_url, :string
    add_column :npos, :guidestar_url, :string
  end

  def self.down
    remove_column :npos, :guidestar_url
    remove_column :npos, :facebook_url
    remove_column :npos, :twitter_name
    remove_column :npos, :attention
    remove_column :npos, :zip_code
    remove_column :npos, :state
    remove_column :npos, :city
    remove_column :npos, :address_2
    remove_column :npos, :address_1
  end
end