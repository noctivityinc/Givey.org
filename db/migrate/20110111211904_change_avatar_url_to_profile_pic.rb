class ChangeAvatarUrlToProfilePic < ActiveRecord::Migration
  def self.up
    rename_column :users, :avatar_url, :profile_pic
  end

  def self.down
    rename_column :users, :profile_pic, :avatar_url
  end
end