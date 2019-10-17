class DiseaseSymptom < ApplicationRecord
  belongs_to :disease
  belongs_to :symptom
end
