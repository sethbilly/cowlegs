require 'rails_helper'

RSpec.describe CaseSymptom, type: :model do
  it { is_expected.to belong_to(:case) }
  it { is_expected.to belong_to(:symptom) }
end
