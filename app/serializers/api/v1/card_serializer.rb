class Api::V1::CardSerializer < Api::BaseSerializer
  attributes :id, :farmer_id, :card_number, :created_at
end