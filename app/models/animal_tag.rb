class AnimalTag < ApplicationRecord
  belongs_to :farmer

  has_many :animal_tag_vaccinations
end
