class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :slug, null: false
      t.boolean :enabled, default: false
      t.integer :seq

      t.timestamps
    end

    add_index :locations, :slug
    add_index :locations, :enabled
    add_index :locations, :seq
  end
end
