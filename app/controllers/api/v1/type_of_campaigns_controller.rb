class Api::V1::TypeOfCampaignsController < ApplicationController
	before_action :authenticate_user!

	include Swagger::Blocks

	def index
		@type_of_campaigns = TypeOfCampaign.all
		render json:
		        @type_of_campaigns,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::TypeOfCampaignSerializer,
		      adapter: :attributes
	end

	def campaign_type_list
		@type_of_campaigns = []
		TypeOfCampaign.find_each do |campaign_type|
			if Time.parse(campaign_type.created_at.to_s) > Time.parse(time_stamp_params[:time_stamp])
				@type_of_campaigns << campaign_type
			end
		end

		render json:
		         @type_of_campaigns,
		       serializer: ActiveModel::Serializer::CollectionSerializer,
		       each_serializer: Api::V1::TypeOfCampaignSerializer,
		       adapter: :attributes
	end

	def type_of_campaign_select_options
		@campaign_types = TypeOfCampaign.all
		render json: @campaign_types, each_serializer: Api::V1::TypeOfCampaignSelectSerializer
	end

	private

	def time_stamp_params
		params.require(:data).permit(
			:time_stamp
		)
	end
end