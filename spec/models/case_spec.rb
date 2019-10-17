require 'rails_helper'

RSpec.describe Case, type: :model do
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:pictures) }

  context 'if is_active' do
    before { allow(subject).to receive(:is_active?).and_return(true) }
    it { is_expected.to validate_presence_of(:community) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:sex) }
    it { is_expected.to validate_presence_of(:system) }
    it { is_expected.to validate_presence_of(:number_dead) }
    it { is_expected.to validate_presence_of(:number_at_risk) }
    it { is_expected.to validate_presence_of(:number_examined) }
    it { is_expected.to validate_presence_of(:measures_adopted) }
    it { is_expected.to have_many(:symptoms).through(:case_symptoms).dependent(:destroy) }
   end
end
