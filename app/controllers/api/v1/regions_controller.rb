class Api::V1::RegionsController < ApplicationController
	before_action :authenticate_user!

	include Swagger::Blocks

	swagger_path '/api/v1/regions' do
	  operation :get do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of regions."
	    key :operationId, 'GetRegions'

	    key :tags, [
	      'Region'
	    ]

	    parameter do
	      key :name, :page
	      key :in, :query
	      key :description, 'Page number'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    parameter do
	      key :name, :per_page
	      key :in, :query
	      key :description, 'Number of records to fetch for page'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns list of Region objects'
	      schema type: :array do
	        items do
	          key :'$ref', :Region
	        end
	      end
	    end

	  end
	end
	def index
		@regions = Region.all
		paginate json: @regions
  end
  
  def all_regions
    @regions = Region.all
    render json:
		        @regions,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::RegionSerializer,
		      adapter: :attributes
  end
  

	def region_select_options
		@regions = Region.all
		render json: @regions, each_serializer: Api::V1::RegionSelectSerializer
	end
end