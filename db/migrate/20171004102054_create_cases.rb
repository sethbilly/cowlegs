class CreateCases < ActiveRecord::Migration[5.1]
  def change
    create_table :cases do |t|
      t.integer :type_of_case, default: 0
      t.references :species, foreign_key: true
      t.references :user, foreign_key: true
      t.text :description
      t.boolean :feed_changed
      t.integer :lasted_for
      t.integer :number_of_animals
      t.string :pictures, array: true, default: []
      t.jsonb :location, null: false, default: '{}'

      t.timestamps
    end
  end
end
