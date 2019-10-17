module Api
  module V1
    class FarmerSerializer < Api::BaseSerializer
      attributes(
        :id,
        :slug,
        :first_name,
        :last_name,
        :phone_number,
        :sex,
        :age,
        :level_of_education,
        :community,
        :community_id,
        :household_name,
        :house_id,
        :farm_name,
        :farm_location,
        :alternate_phone_number,
        :livestock_keeping_reason,
        :years_since_farm_started,
        :source_of_feeding,
        :production_challenges,
        :action_taken_when_animal_is_sick,
        :action_taken_when_animal_care_info_is_needed,
        :how_disease_outbreak_is_known,
        :action_taken_when_disease_outbreak,
        :service_subscription,
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
        :type_of_cattle_vaccination,
        :period_of_cattle_vaccination,
        :sheep_and_goats_vaccinated_this_year,
        :type_of_sheep_and_goats_vaccination,
        :period_of_sheep_and_goats_vaccination,
        :own_a_phone,
        :type_of_phone,
        :phone_is_used_for,
        :use_mobile_money,
        :last_use_of_mobile_money,
        :why_not_use_mobile_money,
        :how_phone_is_charged,
        :how_airtime_is_topped_up,
        :have_bank_account,
        :type_of_bank,
        :bank_saving,
        :type_of_bank_saving,
        :location,
        :picture,
        :subscription,
        :birds_vaccinated_this_year,
        :period_of_birds_vaccination,
        :have_internet,
        :type_of_birds_vaccination,
        :user,
        :id_type,
        :id_number,
        :languages_spoken,
        :subscribed,
        :created_at,
        :updated_at,
        :number_of_sheep,
        :number_of_goats,
        :number_of_cattle,
        :number_of_chicken,
        :number_of_pigs,
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
        :source_of_buying_fertilizer,
        :is_purchase_tractor_services,
        :is_purchase_seeds,
        :source_of_buying_seeds,
        :number_of_npk_bags,
        :number_of_urea_bags,
        :number_of_soa_bags,
        :types_of_fertilizers,
        :district_select_options,
        :zone_select_options,
        :community_select_options,
        :number_of_campaign_animals,
        :total_expected_revenue_from_campaign
      )

      belongs_to :region, optional: true, serializer: Api::V1::CustomRegionSerializer
      belongs_to :district, optional: true, serializer: Api::V1::CustomDistrictSerializer
      belongs_to :zone, optional: true
      belongs_to :community, optional: true, serializer: Api::V1::CustomCommunitySerializer
      has_many :vaccination_schedules
      has_many :payments
      has_many :animal_tags
      has_one :card

      def number_of_campaign_animals
        if instance_options[:campaign_id]
          schedule = VaccinationSchedule.where({
            campaign_id: instance_options[:campaign_id],
            farmer_id: object.id
          }).first

          unless schedule.nil?
            return schedule.herd_size
          end
        end
      end
      
      def total_expected_revenue_from_campaign
        if instance_options[:campaign_id]
          campaign = Campaign.find_by_id(instance_options[:campaign_id])
          schedule = VaccinationSchedule.where({
            campaign_id: instance_options[:campaign_id],
            farmer_id: object.id
          }).first

          if !schedule.nil? && !campaign.nil?
            return (campaign.unit_cost_of_vaccine * schedule.herd_size).round(2)
          end
        end
      end
      

      def subscription
        object.current_subscription
      end

      def district_select_options
        region_id = object.region_id
        if region_id.nil?
          return []
        end
        # we don't want to trigger 404
        districts = Region.find_by_id(region_id).districts
        options = []
        districts.each do |d|
          options << Api::V1::DistrictSelectSerializer.new(d).attributes
        end
        options
      end

      def zone_select_options
        district_id = object.district_id
        if district_id.nil?
          return []
        end
        # we don't want to trigger 404
        zones = District.find_by_id(district_id).zones
        options = []
        zones.each do |z|
          options << Api::V1::ZoneSelectSerializer.new(z).attributes
        end
        options
      end

      def community_select_options
        zone_id = object.zone_id
        if zone_id.nil?
          return []
        end
        # we don't want to trigger 404
        communities = Zone.find_by_id(zone_id).communities
        options = []
        communities.each do |c|
          options << Api::V1::CommunitySelectSerializer.new(c).attributes
        end
        options
      end

      def user
        # don't use find to trigger 404
        # technically a farmer has one user
        user = User.find_by_id(object.users.pluck(:id).first)
        if user
          Api::V1::CustomUserSerializer.new(user).attributes
        end
      end

      def payments
        object.payments.limit(10)
      end

      def location
        if object.location.class == String
          ActiveSupport::JSON.decode(object.location)
        elsif object.location.class == Hash
          object.location
        end
      end

    end
  end
end
