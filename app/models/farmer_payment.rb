class FarmerPayment < ApplicationRecord
  belongs_to :farmer
  belongs_to :payment
end
