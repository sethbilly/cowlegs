class Api::V1::CampaignSerializer < Api::BaseSerializer
  attributes :id, :slug, :delivery_date, :type_of_campaign, :unit_cost_of_vaccine,
  :total_zones, :total_farmers, :total_animals, :total_providers, :estimated_revenue,
  :completion_date, :zone_ids, :type_of_campaign_id, :status, :user_ids, :district_select_options,
  :region_id, :district_id, :zone_select_options, :region_id, :district_id,
  :code, :created_at, :updated_at

  has_many :zones
  has_many :users, serializer: Api::V1::CustomUserSerializer
	has_many :messages
  has_many :vaccination_schedules
  
  def total_zones
    object.zones.size
  end
  
  def total_farmers
    Farmer.where(id: object.vaccination_schedules.pluck(:farmer_id).uniq).size
  end

  def total_animals
    object.vaccination_schedules.sum(:herd_size)
  end
  
  def total_providers
    object.users.size
  end
  
  def estimated_revenue
    (object.unit_cost_of_vaccine * object.vaccination_schedules.sum(:herd_size)).round(2)
  end
  

	def type_of_campaign
		# lets not trigger 404
		tc = TypeOfCampaign.find_by_id(object.type_of_campaign_id)
		if tc.nil?
			return ''
		end
		tc.type_of_campaign
	end

	def zone_ids
		object.zone_ids
  end
  
  def user_ids
		object.user_ids
  end
  
  def district_select_options
    # we don't want to trigger 404
    districts = Region.find_by_id(object.region_id).districts
    options = []
    districts.each do |d|
      options << Api::V1::DistrictSelectSerializer.new(d).attributes
    end
    options
  end

  def zone_select_options
    # we don't want to trigger 404
    zones = District.find_by_id(object.district_id).zones
    options = []
    zones.each do |z|
      options << Api::V1::ZoneSelectSerializer.new(z).attributes
    end
    options
  end
	
end