class CampaignMessage < ApplicationRecord
  belongs_to :message
  belongs_to :campaign
end
