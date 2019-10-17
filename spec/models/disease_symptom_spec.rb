require 'rails_helper'

RSpec.describe DiseaseSymptom, type: :model do
  it { is_expected.to belong_to(:disease) }
  it { is_expected.to belong_to(:symptom) }
end
