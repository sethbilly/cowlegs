class AnimalTagVaccination < ApplicationRecord
  belongs_to :animal_tag
  belongs_to :user
end
