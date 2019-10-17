class CreateSymptoms < ActiveRecord::Migration[5.1]
  def change
    create_table :symptoms do |t|
      t.text :description
      t.references :disease, foreign_key: true

      t.timestamps
    end
  end
end
