class Api::V1::SessionsController < ApplicationController
	include Swagger::Blocks

	swagger_path '/v1/sessions' do
	  operation :post do
	    extend SwaggerResponses::AuthenticationError
	    key :description, 'Signs in a user'
	    key :operationId, 'SignInUser'

	    key :tags, [
	      'User'
	    ]

	    parameter do
	      key :name, :data
	      key :in, :body
	      key :description, "Root data object. Supply either `email` or `username`"
	      key :required, true
	      key :type, :object
	      schema do
	        key :'$ref', :SignInUserInput
	      end
	    end

	    response 200 do
	      key :description, 'Returns User data in response body and ACCESS-TOKEN in response headers'
	      schema do
	        key :'$ref', :UserDataResponse
	      end
	    end
	  end
	end

	def create
		unless session_params[:email].nil?
			@user = User.find_by_email(session_params[:email])
		end

		unless session_params[:username].nil?
			@user = User.find_by_username(session_params[:username])
		end

		error_payload = { "email or password": "is invalid" }

		if @user.nil?
			render_error_payload(:invalid_credentials, error_payload, status: 401)
			return
		end
		
		valid_password = @user.valid_password?(session_params[:password])
		if valid_password
			sign_in(:user, @user)
			token = JWTWrapper.encode(user_id: @user.id)
			response.headers['ACCESS-TOKEN'] = token
			render json: { 'success': true, 'data': Api::V1::UserSerializer.new(@user).attributes }
		else
			render_error_payload(:invalid_credentials, error_payload, status: 401)
		end
	end

	private

	def session_params
		params.require(:data).permit(
			:email,
			:username,
			:password
		)
	end
end