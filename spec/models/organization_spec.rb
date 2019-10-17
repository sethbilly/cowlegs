require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'Validations' do
  	it { is_expected.to validate_presence_of(:name) }
  	it { is_expected.to validate_presence_of(:region) }
  	it { is_expected.to validate_presence_of(:district) }
  	it { is_expected.to validate_presence_of(:postal_address) }
  	it { is_expected.to validate_presence_of(:number_of_staff) }
  	it { is_expected.to have_many(:users).through(:user_organizations).dependent(:destroy) }
  	it { is_expected.to have_many(:farmers).through(:organization_farmers).dependent(:destroy) }
  end
end
