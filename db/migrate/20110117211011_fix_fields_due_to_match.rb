class FixFieldsDueToMatch < ActiveRecord::Migration
  def self.up
    remove_column :campaigns, :friends_hash
    rename_column :duels, :winner_id, :winner_uid
    rename_column :duels, :challenger_ids, :challenger_uids
    rename_column :duels, :campaign_id, :match_id
  end

  def self.down
    rename_column :duels, :match_id, :campaign_id
    rename_column :duels, :challenger_uids, :challenger_ids
    rename_column :duels, :winner_uid, :winner_id
    add_column :campaigns, :friends_hash, :text
  end
end