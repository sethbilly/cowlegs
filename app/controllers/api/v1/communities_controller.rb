class Api::V1::CommunitiesController < ApplicationController
	before_action :authenticate_user!
  include Swagger::Blocks

  swagger_path '/v1/communities' do
    operation :get do
      extend SwaggerResponses::AuthenticationError
      key :description, "Get list of communities."
      key :operationId, 'GetCommunities'

      key :tags, [
          'Community'
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
        key :description, 'Returns list of Json objects'
        schema type: :array do
          items do
            key :'$ref', :Community
          end
        end
      end
    end
  end

  swagger_path '/v1/communities' do
    operation :post do
      extend SwaggerResponses::AuthenticationError
      key :description, "Get list of communities."
      key :operationId, 'GetCommunities'

      key :tags, [
          'Community'
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
        key :description, 'Returns list of Json objects'
        schema type: :array do
          items do
            key :'$ref', :Community
          end
        end
      end
    end
  end

  swagger_path '/v1/communities/{id}' do
    operation :get do
      extend SwaggerResponses::AuthenticationError
      key :description, "Shows Community Detail."
      key :operationId, 'GetCommunity'

      key :tags, [
          'Community'
      ]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of Community  to show'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      security do
        key :access_token, []
      end

      response 200 do
        key :description, 'Returns a Community object'
        schema do
          key :'$ref', :Community
        end
      end
    end
  end

  swagger_path '/v1/communities/{id}' do
    operation :put do
      key :description, "Use this route to a community's detail."
      key :operationId, 'ChangeCommunityDetail'

      key :tags, [
          'Community'
      ]

      parameter do
        key :name, :client
        key :in, :header
        key :description, 'value of `client_id` contained in url params'
        key :required, true
        key :type, :string
      end

      parameter do
        key :name, :access_token
        key :in, :header
        key :description, 'value of `token` contained in url params'
        key :required, true
        key :type, :string
      end

      parameter do
        key :name, :uid
        key :in, :header
        key :description, 'value of `uid` contained in url params'
        key :required, true
        key :type, :string
      end

      parameter do
        key :name, :zone_id
        key :in, :body
        key :description, 'Zone ID of the Community'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      parameter do
        key :name, :lat
        key :in, :body
        key :description, 'Latitude of the community'
        key :required, true
        key :type, :string
        end

      parameter do
        key :name, :lng
        key :in, :body
        key :description, 'Longitude of the community'
        key :required, true
        key :type, :string
        end

      parameter do
        key :name, :address
        key :in, :body
        key :description, 'Address of the community'
        key :required, true
        key :type, :string
      end

      response 200 do
        key :description, 'Returns a JSON object.'
        schema do
          key :'$ref', :Community
        end
      end
    end
  end

  swagger_path '/v1/communities/{id}' do
    operation :delete do
      extend SwaggerResponses::AuthenticationError
      key :description, "Deletes a Community."
      key :operationId, 'DeleteCommunity'

      key :tags, [
          'Community'
      ]

      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of Community to delete'
        key :required, true
        key :type, :integer
        key :format, :int64
      end

      security do
        key :access_token, []
      end

      response 204 do
        key :description, 'Returns nothing if successfull'
      end
    end
  end

	def create
    @community = Community.new(communities_params)
    if @community.save
      render json:
		        @community,
		      serializer: Api::V1::CommunitySerializer,
		      adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @community.errors, status: 422) 
    end
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(communities_params)
      render json:
		        @community,
		      serializer: Api::V1::CommunitySerializer,
          adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @community.errors, status: 422) 
    end
  end
  
  def destroy
		@community = Community.find(params[:id])
		if @community.destroy
		  render :nothing, status: :no_content
		else
		  head 422
		end
	end
  
  def communites_for_zone_select_options
		@zone = Zone.find(params[:id])
		render json: @zone.communities, each_serializer: Api::V1::CommunitySelectSerializer
	end
  
  private

  def communities_params
    params.require(:community).permit(
      :zone_id,
      :address,
      :lat,
      :lng
	  )
  end
  
end