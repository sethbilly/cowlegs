class Api::V1::AnimalTagVaccinationSerializer < Api::BaseSerializer
  attributes :id, :user_id, :animal_tag_id, :type_of_vaccination, :notes,
  :created_at, :updated_at
end