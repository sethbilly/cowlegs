class OrganizationFarmer < ApplicationRecord
  belongs_to :organization
  belongs_to :farmer
end
