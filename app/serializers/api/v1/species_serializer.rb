class Api::V1::SpeciesSerializer < Api::BaseSerializer
  attributes :id, :name, :created_at, :updated_at, :species_id

  def species_id
  	object.id
  end
end
