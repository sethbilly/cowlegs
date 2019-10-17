class SpeciesDisease < ApplicationRecord
  belongs_to :species
  belongs_to :disease
end
