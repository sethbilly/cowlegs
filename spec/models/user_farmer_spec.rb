require 'rails_helper'

RSpec.describe UserFarmer, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:farmer) }
end
