class Api::V1::AnimalTagSerializer < Api::BaseSerializer
  attributes :id, :farmer_id, :bid_number, :tag_number, :type_of_animal,
  :age, :sex, :notes, :breed, :animal_tag_vaccinations, :created_at, :updated_at

  def animal_tag_vaccinations
    object.animal_tag_vaccinations
  end
   
end