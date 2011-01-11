class CreateNpos < ActiveRecord::Migration
  def self.up
    create_table :npos do |t|
      t.string :name
      t.string :website
      t.string :email
      t.text :description
      t.integer :category_id
      t.boolean :feature
      t.integer :num_featured
      t.boolean :active
      t.string :summary
      t.timestamps
    end
  end

  def self.down
    drop_table :npos
  end
end
