class Api::V1::RegistrationsController < ApplicationController
	include Swagger::Blocks

	swagger_path '/v1/registrations' do
	  operation :post do
	    extend SwaggerResponses::ModelCreateError
	    key :description, 'Signs up a new user'
	    key :operationId, 'SignUpUser'

	    key :tags, [
	      'User'
	    ]

	    parameter do
	      key :name, :user
	      key :in, :body
	      key :description, "Root user object. Supply either `agent` or `provider` for the `role` param"
	      key :required, true
	      key :type, :object
	      schema do
	        key :'$ref', :SignUpUserInput
	      end
	    end

	    response 200 do
	      key :description, 'Returns User data in response body and ACCESS-TOKEN in response headers'
	      schema do
	        key :'$ref', :UserResponse
	      end
	    end
	  end
	end

	def create
		@user = User.new(user_params.except(:organization, :owner))
		if @user.save
			if user_params[:organization]
				organization = Organization.new(user_params[:organization])
				if organization.save
					@user.organization_ids = organization.id
				else
					api_error(
					  status: 422,
					  data: params.fetch(:user),
					  errors: organization.errors
					)
					return
				end
			elsif user_params[:owner]
				@user.organization_ids = user_params[:owner][:organization_id]
			end
			sign_in(:user, @user)
		  token = JWTWrapper.encode(user_id: @user.id)
		  response.headers['ACCESS-TOKEN'] = token
		  render json:
		          @user,
		        serializer: Api::V1::UserSerializer
		else
		  api_error(
		    status: 422,
		    data: params.fetch(:user),
		    errors: @user.errors
		  )
		end
	end

	private

	def user_params
	  load_params = params.require(:user).permit(
	  	:username,
	    :email,
	    :password,
	    :first_name,
	    :last_name,
	    :phone_number,
	    :gender,
	    :region,
	    :district,
	    :type_of_id,
	    :id_number,
	    :picture,
	    :date_of_birth,
	    :role
	  )
	  load_params[:location] = params[:user][:location] if params[:user][:location]
	  load_params[:owner] = params[:user][:owner] if params[:user][:owner]
	  load_params[:organization] = params[:user][:organization] if params[:user][:organization]
	  load_params.permit!
	end
end