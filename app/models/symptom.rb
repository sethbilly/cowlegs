class Symptom < ApplicationRecord
  validates :description, presence: true
  has_many :disease_symptoms
  has_many :diseases, through: :disease_symptoms, dependent: :destroy
  has_many :case_symptoms
  has_many :cases, through: :case_symptoms, dependent: :destroy
end
