class CreateCaseSymptoms < ActiveRecord::Migration[5.1]
  def change
    create_table :case_symptoms do |t|
      t.references :case, foreign_key: true
      t.references :symptom, foreign_key: true

      t.timestamps
    end
  end
end
