class AddEmailFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :completed_round_one_at, :datetime
    add_column :users, :emailed_invite_friends_at, :datetime
    add_column :users, :emailed_scores_unlocked_at, :datetime
  end

  def self.down
    remove_column :users, :emailed_scores_unlocked_at
    remove_column :users, :emailed_invite_friends_at
    remove_column :users, :completed_round_one_at
  end
end