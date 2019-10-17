class RemoveDiseaseIdFromSymptoms < ActiveRecord::Migration[5.1]
  def change
    remove_reference :symptoms, :disease, foreign_key: true
  end
end
