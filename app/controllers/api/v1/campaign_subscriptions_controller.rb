class Api::V1::CampaignSubscriptionsController < ApplicationController
  include Swagger::Blocks

  swagger_path '/v1/campaigns/subscribe_to_campaign' do
    operation :post do
      key :description, "Use this route if a farmer wants to subscriber to a campaign"
      key :operationId, 'JoinCampaign'
      key :tags, [
          'Campaign'
      ]
      parameter do
        key :name, :data
        key :in, :body
        key :description, 'Root data object.'
        key :required, true
        key :type, :object
        schema do
          key :'$ref', :AddSubscriberToCampaignInput
        end
      end
      response 200 do
        key :description, 'Returns response object'
        schema do
          key :'$ref', :CampaignSubscription
        end
      end
    end
  end
  swagger_path '/v1/campaigns/unsubscribe_from_campaign' do
    operation :post do
      key :description, "Use this route if a farmer wants to subscriber to a campaign"
      key :operationId, 'UnsubscribeFromCampaign'
      key :tags, [
          'Campaign'
      ]
      parameter do
        key :name, :data
        key :in, :body
        key :description, 'Root data object.'
        key :required, true
        key :type, :object
        schema do
          key :'$ref', :UnsubscribeFromCampaignInput
        end
      end
      response 200 do
        key :description, 'Returns response object'
        schema do
          key :'$ref', :CampaignSubscription
        end
      end
    end
  end

  
  def subscribe_campaign
    defaults = {:subscribed => true}
    params = defaults.merge(add_subscriber_to_campaign_params)
    @campaign_subscription = CampaignSubscription.new(params)
    if @campaign_subscription.save
      render json: @campaign_subscription, serializer: Api::V1::CampaignSubscriptionSerializer, adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @campaign_subscription.errors, status: 422)
    end
  end

  def unsubscribe_campaign
    defaults = {:subscribed => false}
    params = defaults.merge(campaign_subscriptions_params)
    if @campaign_subscription.update(params)
      render json: @campaign_subscription, serializer: Api::V1::CampaignSubscriptionSerializer, adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @campaign_subscription.errors, status: 422)
    end
  end

  def farmer_campaigns
    @campaign_subscriptions = CampaignSubscription.where(farmer_id: @farmer.id)
    paginate json: @campaign_subscriptions
  end

  private

  def campaign_subscriptions_params
    params.permit([:campaign_id, :farmer_id, :subscribed])
  end

  def set_farmer
    @farmer = Farmer.where(phone_number: add_subscriber_to_campaign_params[:phone_number]).take!
  end

  def set_campaign
    @campaign = Campaign.where(code: add_subscriber_to_campaign_params[:campaign_code]).take!
  end

  def set_campaign_subscription
    @campaign_subscription = CampaignSubscription.find(params[:id])
  end

  def add_subscriber_to_campaign_params
    params.require(:data).permit(:campaign_code, :phone_number)
  end

  def unsubscriber_from_campaign_params
    params.require(:data).permit(:campaign_code, :phone_number)
  end

end
