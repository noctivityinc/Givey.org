class AddCandidatesNpoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :candidates_npo_id, :integer
  end

  def self.down
    remove_column :users, :candidates_npo_id
  end
end
