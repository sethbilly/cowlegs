class Disease < ApplicationRecord
	has_many :species_diseases
	has_many :species, through: :species_diseases, dependent: :destroy
	has_many :disease_symptoms
	has_many :symptoms, through: :disease_symptoms, dependent: :destroy
	validates :name, presence: true, uniqueness: true
	validates :description, presence: true
end
