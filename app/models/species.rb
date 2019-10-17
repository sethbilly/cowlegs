class Species < ApplicationRecord
	before_save Proc.new {|species| species.name? ? species.name = species.name.downcase : nil}
	has_many :species_diseases
	has_many :diseases, through: :species_diseases, dependent: :destroy
	has_many :cases, dependent: :destroy
	validates :name, presence: true, uniqueness: true
end
