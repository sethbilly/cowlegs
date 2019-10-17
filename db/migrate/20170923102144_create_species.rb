class CreateSpecies < ActiveRecord::Migration[5.1]
  def change
    create_table :species do |t|
      t.string :name

      t.timestamps
    end
    add_index :species, :name, unique: true
  end
end
