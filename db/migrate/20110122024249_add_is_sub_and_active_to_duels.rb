class AddIsSubAndActiveToDuels < ActiveRecord::Migration
  def self.up
    add_column :duels, :is_sub, :boolean
    add_column :duels, :active, :boolean
  end

  def self.down
    remove_column :duels, :active
    remove_column :duels, :is_sub
  end
end
