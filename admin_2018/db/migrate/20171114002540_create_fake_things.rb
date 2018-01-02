class CreateFakeThings < ActiveRecord::Migration[5.1]
  def change
    create_table :fake_things do |t|
      t.references :location, on_delete: :cascade

      t.string :name
      t.string :slug, null: false
      t.boolean :enabled, default: false
      t.integer :seq
      t.string :image, :string

      t.timestamps
    end

    add_index :fake_things, :slug
    add_index :fake_things, :enabled
    add_index :fake_things, [:location_id, :seq]
  end
end
