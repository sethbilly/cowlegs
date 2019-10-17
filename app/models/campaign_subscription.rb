class CampaignSubscription < ApplicationRecord
  belongs_to :campaign
  belongs_to :farmer
  include Swagger::Blocks

  swagger_schema :CampaignSubscription do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :campaign_id do
      key :type, :integer
      key :format, :int64
    end
    property :farmer_id do
      key :type, :integer
      key :format, :int64
    end
    property :subscribed do
      key :type, :boolean
    end
  end

  swagger_schema :AddSubscriberToCampaignInput do
    allOf do
      schema do
        property :data do
          key :type, :object
          property :campaign_code do
            key :type, :string
          end
          property :phone_number do
            key :type, :string
          end
        end
      end
    end
  end

  swagger_schema :UnsubscribeFromCampaignInput do
    allOf do
      schema do
        property :data do
          key :type, :object
          property :campaign_code do
            key :type, :string
          end
          property :phone_number do
            key :type, :string
          end
        end
      end
    end
  end

end
