class CreateDiseaseSymptoms < ActiveRecord::Migration[5.1]
  def change
    create_table :disease_symptoms do |t|
      t.references :disease, foreign_key: true
      t.references :symptom, foreign_key: true

      t.timestamps
    end
  end
end
