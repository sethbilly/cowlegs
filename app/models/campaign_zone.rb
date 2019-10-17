class CampaignZone < ApplicationRecord
  belongs_to :zone
  belongs_to :campaign
end
