require 'rails_helper'

RSpec.describe Disease, type: :model do
	describe 'Validations' do
		it { is_expected.to validate_presence_of(:name) }
		it { is_expected.to validate_uniqueness_of(:name) }
		it { is_expected.to validate_presence_of(:description) }
		it { is_expected.to have_many(:species_diseases) }
		it { is_expected.to have_many(:species).through(:species_diseases).dependent(:destroy) }
		it { is_expected.to have_many(:symptoms).through(:disease_symptoms).dependent(:destroy) }
	end
end
