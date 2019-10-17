class Api::V1::DiseaseSerializer < Api::BaseSerializer
  attributes :id, :name, :description, :created_at, :updated_at, :disease_id

  has_many :symptoms, through: :disease_symptoms
  has_many :species, through: :species_diseases

  def disease_id
  	object.id
  end
end