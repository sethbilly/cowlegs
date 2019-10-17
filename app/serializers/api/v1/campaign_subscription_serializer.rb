class Api::V1::CampaignSubscriptionSerializer < Api::BaseSerializer
  attributes( :id, :campaign_id, :farmer_id, :subscribed )
end