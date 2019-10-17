require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
  	context 'on a new user' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:phone_number) }
      it { is_expected.to validate_uniqueness_of(:phone_number) }
      it { is_expected.to have_many(:cases).dependent(:destroy) }
      it { is_expected.to have_many(:organizations).through(:user_organizations).dependent(:destroy) }
      it { is_expected.to have_many(:farmers).through(:user_farmers).dependent(:destroy) }
  	end
  end
end