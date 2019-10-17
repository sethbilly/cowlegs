class CreateSpeciesDiseases < ActiveRecord::Migration[5.1]
  def change
    create_table :species_diseases do |t|
      t.references :species, foreign_key: true
      t.references :disease, foreign_key: true

      t.timestamps
    end
  end
end
