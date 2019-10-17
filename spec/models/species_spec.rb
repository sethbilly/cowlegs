require 'rails_helper'

RSpec.describe Species, type: :model do
	describe 'Validations' do
		it { is_expected.to validate_presence_of(:name) }
		it { is_expected.to validate_uniqueness_of(:name) }
		it { is_expected.to have_many(:species_diseases) }
		it { is_expected.to have_many(:cases).dependent(:destroy) }
		it { is_expected.to have_many(:diseases).through(:species_diseases).dependent(:destroy) }
	end
end
