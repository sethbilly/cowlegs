require 'rails_helper'

RSpec.describe SpeciesDisease, type: :model do
  describe 'Validations' do
  	it { is_expected.to belong_to(:species) }
  	it { is_expected.to belong_to(:disease) }
  end
end
