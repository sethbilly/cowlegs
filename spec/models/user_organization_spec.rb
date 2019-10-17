require 'rails_helper'

RSpec.describe UserOrganization, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:organization) }
end
