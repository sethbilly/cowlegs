class Api::V1::DistrictsController < ApplicationController
	before_action :authenticate_user!

	include Swagger::Blocks

	swagger_path '/v1/districts/districts_for_region/{id}' do
	  operation :get do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of districts for a particular region."
	    key :operationId, 'GetDistrictsForRegion'

	    key :tags, [
	      'District'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of Region'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns list of District objects'
	      schema type: :array do
	        items do
	          key :'$ref', :District
	        end
	      end
	    end

	  end
	end
	def districts_for_region
		@region = Region.find(params[:id])
		render json:
		        @region.districts,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::DistrictSerializer,
		      adapter: :attributes
	end

	def district_select_options
		@districts = District.all
		render json: @districts, each_serializer: Api::V1::DistrictSelectSerializer
	end

	def districts_for_region_select_options
		@region = Region.find(params[:id])
		render json: @region.districts, each_serializer: Api::V1::DistrictSelectSerializer
	end
	
end