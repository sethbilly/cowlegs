require 'will_paginate/array'
class Api::V1::UsersController < ApplicationController
	include Swagger::Blocks
	before_action :authenticate_user!

	swagger_path '/v1/auth/password' do
	  operation :post do
	    key :description, "Use this route to send a password reset confirmation email to users that registered by email"
	    key :operationId, 'SendPasswordResetEmail'
	    key :tags, [
	      'User'
	    ]
	    parameter do
	      key :name, :email
	      key :in, :body
	      key :description, 'Email of user'
	      key :required, true
	      key :type, :string
	    end
	    parameter do
	      key :name, :redirect_url
	      key :in, :body
	      key :description, 'Url to redirect user after clicking link inside email.'
	      key :required, true
	      key :type, :string
	    end
	    response 200 do
	      key :description, 'Returns response object'
	      schema do
	        key :'$ref', :SendPasswordResetEmail
	      end
	    end
	  end
	end

		swagger_path '/v1/auth/password' do
		  operation :put do
		    key :description, "Use this route to change users' password."
		    key :operationId, 'ChangePassword'

		    key :tags, [
		      'User'
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
		      key :name, :password
		      key :in, :body
		      key :description, 'Password of user'
		      key :required, true
		      key :type, :string
		    end

		    parameter do
		      key :name, :password_confirmation
		      key :in, :body
		      key :description, 'Password confirmation'
		      key :required, true
		      key :type, :string
		    end

		    response 200 do
		      key :description, 'Returns User data in response body and ACCESS-TOKEN in response headers'
		      schema do
		        key :'$ref', :UserDataResponse
		      end
		    end
		  end
		end

	swagger_path '/api/v1/users' do
	  operation :get do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of users. If the user requesting is an admin then global users would be returned, else, users belonging to the same organization as the requesting user would be returned. Uses Bearer Authorization to authenticate user."
	    key :operationId, 'GetUsers'

	    key :tags, [
	      'User'
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
	          key :'$ref', :UserResponse
	        end
	      end
	    end
	  end
  end

  def index
    @users = User.none
		if current_user.is_admin?
			@users = User.filter(params.slice(:role, :term))
		end
		paginate json: @users
  end

	swagger_path '/v1/users/{id}' do
	  operation :get do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Shows a User profile."
	    key :operationId, 'ShowUserProfile'

	    key :tags, [
	      'User'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of User profile to show'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns a Json object'
	      schema do
	        key :'$ref', :UserResponse
	      end
	    end
	  end
	end
	def show
		if current_user.is_admin?
			@user = User.friendly.find(params[:id])
		elsif current_user.is_manager? || current_user.is_partner?
			organization = current_user.organizations.first
			@user = organization.users.find(params[:id])
		else
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
			return
		end
		render json:
		        @user,
		      serializer: Api::V1::UserSerializer,
		      adapter: :attributes
	end

	def user
		render json: { 'success': true, 'data': Api::V1::UserSerializer.new(current_user).attributes }
	end

	swagger_path '/v1/users/{id}' do
	  operation :put do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Updates a User profile."
	    key :operationId, 'UpdateUserProfile'

	    key :tags, [
	      'User'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of User to update'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    parameter do
	      key :name, :user
	      key :in, :body
	      key :description, 'Root user profile data.'
	      key :required, true
	      key :type, :object
	      schema do
	        key :'$ref', :UpdateUserInput
	      end
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns a User object'
	      schema do
	        key :'$ref', :UserDataResponse
	      end
	    end
	  end
  end

	def update
    @user = User.friendly.find(params[:id])
    @user.attributes = user_update_params.except(:picture)
		if user_update_params[:picture] && user_update_params[:picture].class == ActionDispatch::Http::UploadedFile
			s3 = Aws::S3::Resource.new
      obj = s3.bucket(ENV['S3_BUCKET']).object(user_update_params[:picture].original_filename)
      if obj.upload_file(user_update_params[:picture].tempfile.path)
        @user.attributes = { picture: obj.public_url }
      end
		end
		if @user.save
			render json:
			        @user,
			      serializer: Api::V1::UserSerializer,
			      adapter: :attributes
		else
			render_error_payload(:unprocessable_entity, @user.errors, status: 422)
		end
	end

	swagger_path '/v1/users/{id}' do
	  operation :delete do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Deletes a User profile."
	    key :operationId, 'DeleteUserProfile'

	    key :tags, [
	      'User'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of User profile to delete'
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

	def destroy
		if current_user.is_admin?
			@user = User.friendly.find(params[:id])
		elsif current_user.is_manager? || current_user.is_partner?
			organization = current_user.organizations.first
			@user = organization.users.find(params[:id])
		else	
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
			return
		end
		if @user.destroy
			render :nothing, status: :no_content
		else
		  render_error_payload(:unprocessable_entity, @user.errors, status: 422)
		end
	end

	swagger_path '/api/v1/provider_list' do
	  operation :get do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of provider users. Auth user must be an admin"
	    key :operationId, 'GetProviderUsers'

	    key :tags, [
	      'Provider'
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
	          key :'$ref', :UserResponse
	        end
	      end
	    end

	  end
  end

	def provider_list
		@users = User.none
		if current_user.is_admin?
			load_params =  params.dup
			load_params[:two_roles] = [1, 3]
			load_params.permit!
			@users = User.filter(load_params.slice(:two_roles, :region, :district, :zone, :term))
		end
		paginate json: @users
	end

	swagger_path '/api/v1/agent_list' do
	  operation :get do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of agent users. Auth user must be an admin"
	    key :operationId, 'GetAgentUsers'

	    key :tags, [
	      'Agent'
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
	          key :'$ref', :UserResponse
	        end
	      end
	    end

	  end
  end

	def agent_list
		@users = User.none
		if current_user.is_admin?
			load_params =  params.dup
			load_params[:role] = 0
			load_params.permit!
			@users = User.filter(load_params.slice(:role, :region, :district, :zone, :term))	
		end
		paginate json: @users
	end

	def partner_list
		@users = User.none
		if current_user.is_admin?
			@users = User.where("role = ?", 4)	
		end
		paginate json: @users
	end

	def provider_select_options
		@providers = User.with_role(1)
		render json: @providers, each_serializer: Api::V1::UserSelectSerializer
	end

	def set_firebase_registration_token
		token = firebase_registration_token_params[:token]
		current_devices = current_user.device_ids
		unless current_devices.include? token
			current_devices << token
			current_user.update(device_ids: current_devices)
			render json: { status: 'success', message: 'firebase token successfully set' }
		end
		head 400
	end
	
	def provider_schedules
		render json:
		        VaccinationSchedule.where(campaign_id: current_user.campaigns.pluck(:id)),
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::VaccinationScheduleSerializer,
		      adapter: :attributes
	end

	def updated_provider_schedules
		@schedules = []
		VaccinationSchedule.where(campaign_id: current_user.campaigns.pluck(:id)).find_each do |schedule|
			if Time.parse(schedule.updated_at.to_s) > Time.parse(time_stamp_params[:time_stamp])
				@schedules << schedule
			end
		end
		render json:
		        @schedules,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::VaccinationScheduleSerializer,
		      adapter: :attributes
	end
  
  def new_user_account
    generated_password = Devise.friendly_token.first(8)
    @user = User.new(new_user_account_params.merge(password: generated_password))
    if @user.save
      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      @user.reset_password_token = enc
      @user.reset_password_sent_at = Time.now.utc
      @user.save(validate: false)
      UserNotifierMailer.send_registration_email(@user, generated_password, raw).deliver
      render json:
		          @user,
            serializer: Api::V1::UserSerializer
    else
      api_error(
		    status: 422,
		    data: params.fetch(:data),
		    errors: @user.errors
		  )
    end
    
  end
  

	private

	def user_params
	  load_params = params.require(:user).permit(
	    :email,
	    :first_name,
	    :last_name,
	    :phone_number,
	    :gender,
	    :picture,
      :date_of_birth,
      :role,
	  )
	  load_params[:location] = params[:user][:location] if params[:user][:location]
	  load_params.permit!
  end

  def user_update_params
	  load_params = params.permit(
	    :email,
	    :first_name,
	    :last_name,
	    :phone_number,
	    :gender,
	    :picture,
      :date_of_birth,
      :role,
      :zone_id
	  )
	  load_params.permit!
  end
  
  def new_user_account_params
    params.require(:data).permit(
      :email,
      :first_name,
      :last_name,
      :phone_number,
      :role,
      :zone_id
    )
  end

	def firebase_registration_token_params
    params.require(:data).permit(
      :token
    )
  end

  def time_stamp_params
  	params.require(:data).permit(
  		:time_stamp
  	)
  end
end