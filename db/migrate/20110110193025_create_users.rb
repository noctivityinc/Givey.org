class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :email
      t.string :name
      t.string :gender
      t.string :locale
      t.string :avatar_url
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
