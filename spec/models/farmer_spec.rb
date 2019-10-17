require 'rails_helper'

RSpec.describe Farmer, type: :model do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.to validate_uniqueness_of(:phone_number) }
  it { is_expected.to validate_presence_of(:sex) }
  it { is_expected.to validate_presence_of(:age) }
  it { is_expected.to validate_presence_of(:level_of_education) }
  it { is_expected.to validate_presence_of(:region) }
  it { is_expected.to validate_presence_of(:district) }
  it { is_expected.to validate_presence_of(:community) }
  it { is_expected.to validate_presence_of(:house_id) }
  it { is_expected.to validate_presence_of(:farm_name) }
  it { is_expected.to validate_presence_of(:farm_location) }
  it { is_expected.to validate_presence_of(:livestock_keeping_reason) }
  it { is_expected.to validate_presence_of(:years_since_farm_started) }
  it { is_expected.to validate_presence_of(:source_of_feeding) }
  it { is_expected.to validate_presence_of(:production_challenges) }
  it { is_expected.to validate_presence_of(:action_taken_when_animal_is_sick) }
  it { is_expected.to validate_presence_of(:action_taken_when_animal_care_info_is_needed) }
  it { is_expected.to validate_presence_of(:how_disease_outbreak_is_known) }
  it { is_expected.to validate_presence_of(:action_taken_when_disease_outbreak) }
  it { is_expected.to validate_presence_of(:service_subscription) }
  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:picture) }
  it { is_expected.to have_many(:users).through(:user_farmers).dependent(:destroy) }
  it { is_expected.to have_many(:organizations).through(:organization_farmers).dependent(:destroy) }
end
