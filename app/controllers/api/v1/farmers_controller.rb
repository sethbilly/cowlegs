require 'will_paginate/array'
class Api::V1::FarmersController < ApplicationController
	include Swagger::Blocks
	before_action :authenticate_user!

	swagger_path '/api/v1/farmers' do
	  operation :get do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of Subscribers. This includes active and inactive subscribers. If the user requesting is an admin then global subscribers would be returned, else, subscribers created by the user would be returned."
	    key :operationId, 'GetSubScribers'

	    key :tags, [
	      'Subscriber'
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
	      key :description, 'Returns list of Subscriber objects'
	      schema type: :array do
	        items do
	          key :'$ref', :Farmer
	        end
	      end
	    end
	    
	  end
	end
	def index
		# paginate needs an ActiveRecord::Relation object
		@farmers = Farmer.none
		if current_user.role == 'admin'
			load_params =  params.dup
			load_params[:deleted] = false
			load_params.permit!
			@farmers = Farmer.filter(load_params.slice(:deleted, :region, :district, :zone, :term))
			@farmers = @farmers.with_deleted(false)
		else
			load_params =  params.dup
			load_params[:user] = current_user.id
			load_params[:deleted] = false
			load_params.permit!
			@farmers = Farmer.filter(load_params.slice(:deleted, :user, :region, :district, :zone, :term))
		end
		paginate json: @farmers
	end

	swagger_path '/v1/farmers/{id}' do
	  operation :get do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Shows a Subscriber's profile."
	    key :operationId, 'GetSubscriber'

	    key :tags, [
	      'Subscriber'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of Subscriber profile to show'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns a Subscriber object'
	      schema do
	        key :'$ref', :Farmer
	      end
	    end
	  end
	end
	def show
		@farmer = Farmer.friendly.find(params[:id])
		render json:
		        @farmer,
		      serializer: Api::V1::FarmerSerializer,
		      adapter: :attributes
	end

	def create
		@farmer = Farmer.new(farmer_params.except(:picture))
		if farmer_params[:picture]
			if farmer_params[:picture].class == String
				@farmer.picture = farmer_params[:picture]
			elsif farmer_params[:picture].class == ActionDispatch::Http::UploadedFile
				s3 = Aws::S3::Resource.new
				obj = s3.bucket(ENV['S3_BUCKET']).object(farmer_params[:picture].original_filename)
				if obj.upload_file(farmer_params[:picture].tempfile.path)
				  @farmer.picture = obj.public_url
				end
			end
		end
		@farmer.user_ids = current_user.id
		@farmer.organization_ids = current_user.organization_ids
		if @farmer.save
			render json:
			        @farmer,
			      serializer: Api::V1::FarmerSerializer,
			      adapter: :attributes
		else
			render_error_payload(:unprocessable_entity, @farmer.errors, status: 422)
		end
	end

	def update
		@farmer = Farmer.friendly.find(params[:id])
		@farmer.attributes = farmer_params.except(:picture)
		if farmer_params[:picture]
			if farmer_params[:picture].class == String
				@farmer.attributes = { picture: farmer_params[:picture] }
			elsif farmer_params[:picture].class == ActionDispatch::Http::UploadedFile
				s3 = Aws::S3::Resource.new
				obj = s3.bucket(ENV['S3_BUCKET']).object(farmer_params[:picture].original_filename)
				if obj.upload_file(farmer_params[:picture].tempfile.path)
				  @farmer.attributes = { picture: obj.public_url }
				end
			end
		end
		if @farmer.save
			render json:
			        @farmer,
			      serializer: Api::V1::FarmerSerializer,
			      adapter: :attributes
		else
			render_error_payload(:unprocessable_entity, @farmer.errors, status: 422)
		end
	end

	def destroy
		@farmer = Farmer.friendly.find(params[:id])
		if @farmer.update({ is_deleted: true })
		  render :nothing, status: :no_content
		else
		  head 422
		end
	end

	def new_farmer_list
		paginate json: Farmer.with_deleted(false).with_created_after(time_stamp_params[:time_stamp])
	end

	def updated_farmer_list
		render json:
						Farmer.with_deleted(false).with_updated_after(time_stamp_params[:time_stamp]),
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::FarmerSerializer,
		      adapter: :attributes
	end

	def new_farmers_list
		@farmers = []
		Farmer.find_each do |farmer|
			unless farmer.is_deleted
				if Time.parse(farmer.created_at.to_s) > Time.parse(time_stamp_params[:time_stamp])
					@farmers << farmer
				end
			end
		end
		paginate json: @farmers
	end

	def updated_farmers_list
		@farmers = []
		Farmer.find_each do |farmer|
			unless farmer.is_deleted
				if Time.parse(farmer.updated_at.to_s) > Time.parse(time_stamp_params[:time_stamp])
					@farmers << farmer
				end
			end
		end
		render json:
		        @farmers,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::FarmerSerializer,
		      adapter: :attributes
	end

	swagger_path '/api/v1/farmers/active_subscribers' do
	  operation :post do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of active Subscribers. If the user requesting is an admin then global subscribers would be returned, else, subscribers created by the user would be returned."
	    key :operationId, 'GetActiveSubscribers'

	    key :tags, [
	      'Subscriber'
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
	      key :description, 'Returns list of Subscriber objects'
	      schema type: :array do
	        items do
	          key :'$ref', :Farmer
	        end
	      end
	    end
	  end
	end
	def active_subscribers
		@farmers = Farmer.none
		if current_user.role == 'admin'
			load_params =  params.dup
			load_params[:deleted] = false
			load_params[:active_subscription] = Date.today.beginning_of_day
			load_params.permit!
			@farmers = Farmer.filter(load_params.slice(:deleted, :active_subscription, :region, :district, :zone, :term))
			@farmers = @farmers.with_deleted(false)
		else
			load_params =  params.dup
			load_params[:user] = current_user.id
			load_params[:deleted] = false
			load_params[:active_subscription] = Date.today.beginning_of_day
			load_params.permit!
			@farmers = Farmer.filter(load_params.slice(:deleted, :user, :active_subscription, :region, :district, :zone, :term))
		end
		paginate json: @farmers
	end

	def expired_subscribers
		@farmers = Farmer.none
		if current_user.role == 'admin'
			load_params =  params.dup
			load_params[:deleted] = false
			load_params[:expired_subscription] = Date.today.beginning_of_day
			load_params.permit!
			@farmers = Farmer.filter(load_params.slice(:deleted, :expired_subscription, :region, :district, :zone, :term))
			@farmers = @farmers.with_deleted(false)
		else
			load_params =  params.dup
			load_params[:deleted] = false
			load_params[:user] = current_user.id
			load_params[:expired_subscription] = Date.today.beginning_of_day
			load_params.permit!
			@farmers = Farmer.filter(load_params.slice(:deleted, :user, :expired_subscription, :region, :district, :zone, :term))
		end
		paginate json: @farmers
  end
  
  def range_search
    @search = SubscribersDataSearch.new(range_params)

    render json:
         @search.scope,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::FarmerSerializer,
		      adapter: :attributes
  end
  

  private
  
  def range_params
		params.require(:data).permit(
      :date_from,
      :date_to,
		)
	end

	def farmer_params
		load_params = params.permit(
			:first_name,
			:last_name,
			:phone_number,
			:alternate_phone_number,
			:sex,
			:age,
			:level_of_education,
			:community,
			:household_name,
			:house_id,
			:farm_name,
			:farm_location,
			:livestock_keeping_reason,
			:years_since_farm_started,
			:source_of_feeding,
			:action_taken_when_animal_is_sick,
			:action_taken_when_animal_care_info_is_needed,
			:how_disease_outbreak_is_known,
			:action_taken_when_disease_outbreak,
			:sheep_kept,
			:goats_kept,
			:pigs_kept,
			:cattle_kept,
			:chicken_kept,
			:draught_animals_kept,
			:number_of_donkeys,
			:number_of_horses,
			:number_of_bullocks,
			:number_of_other_draught_animals,
			:cattle_housing_system,
			:goats_and_sheep_housing_system,
			:pigs_housing_system,
			:chicken_housing_system,
			:cattle_vaccinated_this_year,
			:period_of_cattle_vaccination,
			:sheep_and_goats_vaccinated_this_year,
			:period_of_sheep_and_goats_vaccination,
			:number_of_sheep,
			:number_of_goats,
			:number_of_cattle,
			:number_of_chicken,
			:subscribed,
			:number_of_pigs,
			:own_a_phone,
			:type_of_phone,
			:use_mobile_money,
			:how_phone_is_charged,
			:have_bank_account,
			:type_of_bank,
			:bank_saving,
			:type_of_bank_saving,
			:picture,
			:region_id,
			:district_id,
      :zone_id,
      :community_id,
			:id_type,
			:id_number,
			:is_livestock_farmer,
			:is_crop_farmer,
			:is_farm_maize,
			:is_farm_rice,
			:is_farm_soyabeans,
			:is_farm_sorghum,
			:is_farm_cocoa,
			:is_farm_yam,
			:acres_of_maize_farm,
			:acres_of_rice_farm,
			:acres_of_soyabeans_farm,
			:acres_of_sorghum_farm,
			:acres_of_cocoa_farm,
			:acres_of_yam_farm,
			:mode_of_farming,
			:is_use_fertilizer,
			:is_purchase_tractor_services,
			:is_purchase_seeds,
			:number_of_npk_bags,
			:number_of_urea_bags,
			:number_of_soa_bags,
			:last_use_of_mobile_money,
			:why_not_use_mobile_money,
			:birds_vaccinated_this_year,
			:period_of_birds_vaccination,
			:have_internet,
			service_subscription: [],
			production_challenges: [],
			type_of_cattle_vaccination: [],
			type_of_sheep_and_goats_vaccination: [],
			phone_is_used_for: [],
			how_airtime_is_topped_up: [],
			types_of_fertilizers: [],
			source_of_buying_fertilizer: [],
			source_of_buying_seeds: [],
			languages_spoken: [],
			type_of_birds_vaccination: []
		)
		load_params[:location] = params[:location] if params[:location]
		load_params.permit!
	end

	def time_stamp_params
		params.require(:data).permit(
			:time_stamp
		)
	end

	def filtering_params(params)
		params.slice(:region, :district, :zone, :term)
	end
end


# Payment.find_each do |payment|
# 	payment.item = 'subscription'
# 	subscription = Subscription.find_by_id(payment.subscription_id)
# 	unless subscription.nil?
# 		payment.user_payments.build(user_id: subscription.user_id)
# 	end
# 	payment.save
# end
