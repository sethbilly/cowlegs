class Api::V1::ZonesController < ApplicationController
	before_action :authenticate_user!

	include Swagger::Blocks

	swagger_path '/v1/zones/zones_for_district/{id}' do
	  operation :get do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of zones for a particular district."
	    key :operationId, 'GetZonesForDistrict'

	    key :tags, [
	      'Zone'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of District'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns list of Zone objects'
	      schema type: :array do
	        items do
	          key :'$ref', :Zone
	        end
	      end
	    end
	    
	  end
	end
	def zones_for_district
		@district = District.find(params[:id])
		render json:
		        @district.zones,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::ZoneSerializer,
		      adapter: :attributes
	end

	def zone_select_options
		@zones = Zone.all
		render json: @zones, each_serializer: Api::V1::ZoneSelectSerializer
	end

	def zones_for_district_select_options
		@district = District.find(params[:id])
		render json: @district.zones, each_serializer: Api::V1::ZoneSelectSerializer
	end
	
end