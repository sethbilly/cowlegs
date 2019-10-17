require 'rails_helper'

RSpec.describe Symptom, type: :model do
  describe 'Validations' do
  	it { is_expected.to validate_presence_of(:description) }
  	it { is_expected.to have_many(:diseases).through(:disease_symptoms).dependent(:destroy) }
  	it { is_expected.to have_many(:cases).through(:case_symptoms).dependent(:destroy) }
  end
end
