require 'net/http'

class Api::V1::CampaignsController < ApplicationController
	before_action :authenticate_user!

	include Swagger::Blocks

	swagger_path '/api/v1/campaigns' do
	  operation :get do
	  	extend SwaggerResponses::AuthenticationError
	    key :description, "Get list of campaigns. Auth User must be admin."
	    key :operationId, 'GetCampaigns'

	    key :tags, [
	      'Campaign'
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
	      key :description, 'Returns list of Campaign objects'
	      schema type: :array do
	        items do
	          key :'$ref', :Campaign
	        end
	      end
	    end

	  end
	end
	def index
		@campaigns = Campaign.none # empty ActiveRecord::Relation object
		if current_user.is_admin?
			@campaigns = Campaign.all
		end
		paginate json: @campaigns
	end

	swagger_path '/v1/campaigns/{id}' do
	  operation :get do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Shows a Campaign."
	    key :operationId, 'ShowCampaign'

	    key :tags, [
	      'Campaign'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of Campaign to show'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns a Campaign object'
	      schema do
	        key :'$ref', :Campaign
	      end
	    end
	  end
	end
	def show
		@campaign = Campaign.friendly.find(params[:id])
		render json:
		        @campaign,
		      serializer: Api::V1::CampaignSerializer,
		      adapter: :attributes
	end

	swagger_path '/v1/campaigns' do
	  operation :post do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Creates a Campaign. Auth User must be admin"
	    key :operationId, 'CreateCampaign'

	    key :tags, [
	      'Campaign'
	    ]

	    parameter do
	      key :name, :campaign
	      key :in, :body
	      key :description, 'Root campaign data.'
	      key :required, true
	      key :type, :object
	      schema do
	        key :'$ref', :CampaignInput
	      end
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns a Campaign object'
	      schema do
	        key :'$ref', :Campaign
	      end
	    end
	  end
	end
	def create
    if current_user.is_admin?
      vaccination_schedule_ids = VaccinationSchedule.with_pending.with_zones(campaign_params[:zone_ids]).pluck(:id)
      if vaccination_schedule_ids.empty?
        render_error_payload(:unprocessable_entity, { 'No pending schedules found': 'from selected zone(s).' }, status: 422)
        return
      end
			@campaign = Campaign.new(campaign_params.merge({ vaccination_schedule_ids: vaccination_schedule_ids }))
			if @campaign.save
				@campaign.save #friendlyId is not generating slug on first save
				
				firebase_uri = URI(FIREBASE_FCM_SEND_URL)
				@campaign.users.each do |user|
					ids_to_remove = []
					user.device_ids.each do |device|
						json_data = {
							data: {
								campaign: {
									notification: {
										title: 'New Vaccination Schedule',
										message: 'You have received a new vaccination schedule',
										timestamp: Time.now.to_datetime.iso8601,
										image: ''
									},
									data: Api::V1::CampaignSerializer.new(@campaign).attributes.tap do |h|
										h[:vaccination_schedules] = @campaign.vaccination_schedules
									end
								}
							},
							to: device
						}.to_json
					
						Net::HTTP.start(
							firebase_uri.host,
							firebase_uri.port,
							use_ssl: firebase_uri.scheme == 'https'
						) do |http|
							request = Net::HTTP::Post.new firebase_uri
							request.body = json_data
							request.content_type = 'application/json'
							request.add_field 'Authorization', "key=#{ENV['FIREBASE_SERVER_KEY']}"
							response = http.request request

							parsed_json = ActiveSupport::JSON.decode(response.body)

							if parsed_json.key?('failure') && parsed_json['failure'] == 1
								ids_to_remove << device
							end
							pp parsed_json
						end
					end
					unless ids_to_remove.empty?
						current_devices = user.device_ids
						diff = current_devices - ids_to_remove | ids_to_remove - current_devices
						user.update(device_ids: diff)
					end
				end
				
				render json:
								@campaign,
							serializer: Api::V1::CampaignSerializer,
							adapter: :attributes
			else
				render_error_payload(:unprocessable_entity, @campaign.errors, status: 422)
			end
			# uri = URI("https://api.mnotify.com/api/voice/quick?key=#{ENV['MNOTIFY_API_KEY']}")
			# recipients = []
			# campaign_params[:vaccination_schedule_ids].each do |schedule_id|
			# 	schedule = VaccinationSchedule.find_by_id(schedule_id)
			# 	unless schedule.nil?
			# 		farmer = schedule.get_farmer
			# 		unless farmer.nil?
			# 			if !farmer.phone_number
			# 				recipients << farmer.alternate_phone_number
			# 			else
			# 				recipients << farmer.phone_number
			# 			end
			# 		end
			# 	end
			# end

			# j_data = {}.tap do |h|
			# 	h[:campaign] = campaign_message_params[:campaign]
			# 	h['file'] = campaign_message_params[:file].tempfile.path
			# 	h[:is_schedule] = campaign_message_params[:is_schedule]
			# 	h[:schedule_date] = campaign_message_params[:schedule_date]
			# 	h[:recipient] = recipients
			# end

			# Net::HTTP.start(
			# 	uri.host,
			# 	uri.port,
			# 	use_ssl: uri.scheme == 'https'
			# ) do |http|
			# 	req = Net::HTTP::Post.new uri
			# 	req.body = j_data.to_json
			# 	req.content_type = 'application/json'
			# 	response = http.request req
				
			# 	parsed_json = ActiveSupport::JSON.decode(response.body)

			# 	logger.debug parsed_json

			# 	if response.code == '200' && !parsed_json.empty? && parsed_json.include?('summary')
			# 		summary = parsed_json.fetch('summary')
			# 		unless summary.empty?
			# 			message_id = summary.fetch('_id')
			# 			voice_id = summary.fetch('voice_id')
			# 			title = campaign_message_params[:campaign]
			# 			@campaign.messages.build({
			# 				message_id: message_id,
			# 				voice_id: voice_id,
			# 				title: title
			# 			})
			# 		end
			# 	end
			# 	# 
			# end
		else
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
		end
	end

	swagger_path '/v1/campaigns/add_provider_to_campaign' do
	  operation :post do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Adds Provider to a Campaign. Auth User must be admin"
	    key :operationId, 'AddProviderToCampaign'

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
	        key :'$ref', :AddProviderToCampaignInput
	      end
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Json object'
	      schema do
	        key :'$ref', :SuccessResponse
	      end
	    end

	  end
	end
	def add_provider_to_campaign
		if current_user.is_admin?
			campaign = Campaign.find(add_provider_to_campaign_params[:campaign_id])
			user = User.find(add_provider_to_campaign_params[:provider_id])
			if user.is_provider?
				campaign.user_ids = user.id
				if campaign.save
					render json: { success: true, 'data': Api::V1::CampaignSerializer.new(campaign).attributes }
					# send notification (voice, sms) to farmer
				else
					render_error_payload(:unprocessable_entity, campaign.errors, status: 422)
				end
			else
				render_error_payload(:not_provider, nil, status: 400)
			end
		else
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
		end
	end

	swagger_path '/v1/campaigns/add_schedule_to_campaign' do
	  operation :post do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Adds Vaccination Schedule to a Campaign. Auth User must be admin"
	    key :operationId, 'AddVaccinationScheduleToCampaign'

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
	        key :'$ref', :AddScheduleToCampaignInput
	      end
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Json object'
	      schema do
	        key :'$ref', :SuccessResponse
	      end
	    end

	  end
	end
	def add_schedule_to_campaign
		if current_user.is_admin?
			campaign = Campaign.find(add_schedule_to_campaign_params[:campaign_id])
			campaign.vaccination_schedule_ids = add_schedule_to_campaign_params[:vaccination_schedule_id]
			if campaign.save
				render json: { success: true, 'data': Api::V1::CampaignSerializer.new(campaign).attributes }
				# send notification (voice, sms) to farmer
			else
				render_error_payload(:unprocessable_entity, campaign.errors, status: 422)
			end
		else
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
		end
	end

	swagger_path '/v1/campaigns/{id}' do
	  operation :put do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Updates a Campaign. Auth User must be admin"
	    key :operationId, 'UpdateCampaign'

	    key :tags, [
	      'Campaign'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of Campaign to update'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    parameter do
	      key :name, :campaign
	      key :in, :body
	      key :description, 'Root campaign data.'
	      key :required, true
	      key :type, :object
	      schema do
	        key :'$ref', :CampaignInput
	      end
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns a Campaign object'
	      schema do
	        key :'$ref', :CampaignDataResponse
	      end
	    end

	  end
	end
	def update
		if current_user.is_admin?
			@campaign = Campaign.friendly.find(params[:id])
			if @campaign.update(campaign_params)
				render json:
				        @campaign,
				      serializer: Api::V1::CampaignSerializer,
				      adapter: :attributes
			else
				render_error_payload(:unprocessable_entity, @campaign.errors, status: 422)
			end
		else
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
		end
	end

	swagger_path '/v1/campaigns/{id}' do
	  operation :delete do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Deletes a Campaign. Auth User must be admin"
	    key :operationId, 'DeleteCampaign'

	    key :tags, [
	      'Campaign'
	    ]

	    parameter do
	      key :name, :id
	      key :in, :path
	      key :description, 'ID of Campaign to delete'
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
			@campaign = Campaign.friendly.find(params[:id])
			if @campaign.destroy
				# sync agent devices
				render :nothing, status: :no_content
			else
			  render_error_payload(:unprocessable_entity, @campaign.errors, status: 422)
			end
		else
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
		end
	end

	def campaigns_list
		@campaigns_list = []
		if campaigns_list_params[:time_stamp] == 0
			Campaign.find_each do |campaign|
				if campaign.start_date > Date.today
					@campaigns_list << campaign
				end
			end
		else
			Campaign.find_each do |campaign|
				if campaign.start_date > Date.today
					if Time.parse(campaign.updated_at.to_s) > Time.parse(campaigns_list_params[:time_stamp])
						@campaigns_list << campaign
					end
				end
			end
		end

		render json:
		         @campaigns_list,
		       serializer: ActiveModel::Serializer::CollectionSerializer,
		       each_serializer: Api::V1::CampaignSerializer,
		       adapter: :attributes
	end

	swagger_path '/v1/campaigns/vaccination_schedules/{campaign_id}' do
	  operation :get do
	    extend SwaggerResponses::AuthenticationError
	    key :description, "Shows Vaccination Schedules for a Campaign."
	    key :operationId, 'ShowVaccinationSchedules'

	    key :tags, [
	      'VaccinationSchedule'
	    ]

	    parameter do
	      key :name, :campaign_id
	      key :in, :path
	      key :description, 'ID of Campaign to show Vaccination Schedules for'
	      key :required, true
	      key :type, :integer
	      key :format, :int64
	    end

	    security do
	      key :access_token, []
	    end

	    response 200 do
	      key :description, 'Returns list of Vaccination Schedules objects'
	      schema type: :array do
	        items do
	          key :'$ref', :VaccinationSchedule
	        end
	      end
	    end

	  end
	end
	def vaccination_schedules
		@campaign = Campaign.find(params[:campaign_id])
		render json:
		         @campaign.vaccination_schedules,
		       serializer: ActiveModel::Serializer::CollectionSerializer,
		       each_serializer: Api::V1::VaccinationScheduleSerializer,
		       adapter: :attributes
	end
	
	def scheduled_campaigns
    data = {}
		if current_user.role == 'admin'
			load_params = params.dup
			load_params[:status] = 0
			load_params.permit!
      campaigns = Campaign.filter(load_params.slice(:status, :region, :district, :zone))
      paginated_campaigns = paginate campaigns
      
      data.tap do |h|
        h[:total_zones] = Zone.where(id: VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).pluck(:zone_id).uniq).size
        h[:total_farmers] = Farmer.where(id: VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).pluck(:farmer_id).uniq).size
        h[:total_animals] = VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).sum(:herd_size)
        h[:total_providers] = User.where(id: ProviderCampaign.where(campaign_id: campaigns.pluck(:id)).pluck(:user_id).uniq).size
        h[:estimated_revenue] = (campaigns.sum(:unit_cost_of_vaccine) * VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).sum(:herd_size)).round(2)
        h[:campaigns] = ActiveModel::Serializer::CollectionSerializer.new(paginated_campaigns, serializer: Api::V1::CampaignSerializer)
      end
		end
		render json: data
  end
  
  def live_campaigns
    data = {}
		if current_user.role == 'admin'
			load_params = params.dup
			load_params[:status] = 1
			load_params.permit!
      campaigns = Campaign.filter(load_params.slice(:status, :region, :district, :zone))
      paginated_campaigns = paginate campaigns

      data.tap do |h|
        h[:total_zones] = Zone.where(id: VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).pluck(:zone_id).uniq).size
        h[:total_farmers] = Farmer.where(id: VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).pluck(:farmer_id).uniq).size
        h[:total_animals] = VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).sum(:herd_size)
        h[:total_providers] = User.where(id: ProviderCampaign.where(campaign_id: campaigns.pluck(:id)).pluck(:user_id).uniq).size
        h[:estimated_revenue] = (campaigns.sum(:unit_cost_of_vaccine) * VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).sum(:herd_size)).round(2)
        h[:campaigns] = ActiveModel::Serializer::CollectionSerializer.new(paginated_campaigns, serializer: Api::V1::CampaignSerializer)
      end
		end
		render json: data
  end

  def completed_campaigns
    data = {}
		if current_user.role == 'admin'
			load_params = params.dup
			load_params[:status] = 2
			load_params.permit!
      campaigns = Campaign.filter(load_params.slice(:status, :region, :district, :zone))
      paginated_campaigns = paginate campaigns

      data.tap do |h|
        h[:total_zones] = Zone.where(id: VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).pluck(:zone_id).uniq).size
        h[:total_farmers] = Farmer.where(id: VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).pluck(:farmer_id).uniq).size
        h[:total_animals] = VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).sum(:herd_size)
        h[:total_providers] = User.where(id: ProviderCampaign.where(campaign_id: campaigns.pluck(:id)).pluck(:user_id).uniq).size
        h[:estimated_revenue] = (campaigns.sum(:unit_cost_of_vaccine) * VaccinationSchedule.where(campaign_id: campaigns.pluck(:id)).sum(:herd_size)).round(2)
        h[:campaigns] = ActiveModel::Serializer::CollectionSerializer.new(paginated_campaigns, serializer: Api::V1::CampaignSerializer)
      end
		end
		render json: data
  end
  
  def campaign_subscribers
    campaign = Campaign.friendly.find(params[:id])
    subscribers = Farmer.where(id: VaccinationSchedule.with_zones(params[:zone]).where(campaign_id: campaign.id).pluck(:farmer_id).uniq)
    render json:
            subscribers,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::FarmerSerializer,
          adapter: :attributes,
          campaign_id: campaign.id
  end
  

	def list_languages_from_aviato
		if current_user.role == 'admin'
			uri = URI.parse('https://go.votomobile.org/api/v1/languages')
			Net::HTTP.start(
				uri.host,
				uri.port,
				use_ssl: uri.scheme == 'https'
			) do |http|
				request = Net::HTTP::Get.new uri
				request['api_key'] = ENV['VIAMO_API_KEY']
				response = http.request request

				parsed_json = ActiveSupport::JSON.decode(response.body)

				if response.code == '200'
					render json: parsed_json['data']
				else
					head 400
				end
			end
		else
			head 400
		end
	end

	def list_audio_files_from_aviato
		if current_user.role == 'admin'
			uri = URI.parse('https://go.votomobile.org/api/v1/audio_files')
			Net::HTTP.start(
				uri.host,
				uri.port,
				use_ssl: uri.scheme == 'https'
			) do |http|
				request = Net::HTTP::Get.new uri
				request['api_key'] = ENV['VIAMO_API_KEY']
				response = http.request request

				parsed_json = ActiveSupport::JSON.decode(response.body)

				if response.code == '200'
					render json: parsed_json['data']
				else
					head 400
				end
			end
		else
			head 400
		end
	end

	private

	def campaign_params
		load_params = params.permit(
			:type_of_campaign_id,
			:delivery_date,
			:region_id,
			:district_id,
			:unit_cost_of_vaccine,
			:code,
			zone_ids: [],
			user_ids: []
		)
		load_params.permit!
	end

	def campaign_message_params
		load_params = params.permit(
			:campaign,
			:file,
			:is_schedule,
			:schedule_date
		)
		load_params.permit!
	end

	def campaigns_list_params
		params.require(:campaign).permit(
			:time_stamp
		)
	end

	def add_schedule_to_campaign_params
		params.require(:data).permit(
			:campaign_id,
			:vaccination_schedule_id
		)
	end

	def add_provider_to_campaign_params
		params.require(:data).permit(
			:campaign_id,
			:provider_id
		)
	end
	
end