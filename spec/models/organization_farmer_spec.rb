require 'rails_helper'

RSpec.describe OrganizationFarmer, type: :model do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:farmer) }
end
