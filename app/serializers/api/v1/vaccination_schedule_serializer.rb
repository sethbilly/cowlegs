class Api::V1::VaccinationScheduleSerializer < Api::BaseSerializer
	attributes :id, :activity, :type_of_campaign_id, :herd_size,
	:zone_id, :status, :farmer_id, :campaign_id, :animal_group,
	:number_of_animals_vaccinated, :total_charge_for_vaccinations,
	:reschedule_date, :reschedule_reason, :unit_cost_of_vaccine, :delivery_date,
	:completion_date, :notes, :zone, :created_at, :updated_at

	def zone
		# don't use find to avoid 404 response
		Zone.find_by_id(object.zone_id).try(:name)
	end

	def unit_cost_of_vaccine
		# let not trigger 404
		campaign = Campaign.find_by_id(object.campaign_id)
		if campaign.nil?
			0.0
		else
			campaign.unit_cost_of_vaccine
		end
	end

	def delivery_date
		# let not trigger 404
		campaign = Campaign.find_by_id(object.campaign_id)
		unless campaign.nil?
			campaign.delivery_date
		end
	end
end