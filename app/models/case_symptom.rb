class CaseSymptom < ApplicationRecord
  belongs_to :case
  belongs_to :symptom
end
