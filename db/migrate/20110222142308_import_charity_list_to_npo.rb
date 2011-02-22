class ImportCharityListToNpo < ActiveRecord::Migration
  def self.up
    begin
      drop_table :charities
    rescue Exception => e
    end

    add_index :npos, :name
    add_index :npos, [:id, :name], :name => "index_id_name"

  end

  def self.down
    remove_index :npos, :name => :index_id_name
    remove_index :npos, :name
  end
end