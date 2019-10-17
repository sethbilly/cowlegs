class Api::V1::VaccinationSchedulesController < ApplicationController
	before_action :authenticate_user!

	def create
		@vaccination_schedule = VaccinationSchedule.new(vaccination_schedule_params)
		if @vaccination_schedule.save
			render json:
			        @vaccination_schedule,
			      serializer: Api::V1::VaccinationScheduleSerializer,
			      adapter: :attributes
		else
			api_error(
			  status: 422,
			  data: params,
			  errors: @vaccination_schedule.errors
			)
		end
	end

	def update
		@vaccination_schedule = VaccinationSchedule.find(params[:id])
		if @vaccination_schedule.update(vaccination_schedule_params)
			if @vaccination_schedule.status == 'completed'
				payment = Payment.new(
					payment_fee: @vaccination_schedule.total_charge_for_vaccinations,
					payment_method: 'cash', # we need to get this from the param
					item: 'vaccination'
        )
        payment.farmer_payments.build(farmer_id: @vaccination_schedule.farmer_id)
				payment.user_payments.build(user_id: current_user.id)
				payment.save
			end
			
			render json:
			        @vaccination_schedule,
			      serializer: Api::V1::VaccinationScheduleSerializer,
			      adapter: :attributes
		else
			render_error_payload(:unprocessable_entity, @vaccination_schedule.errors, status: 422)
		end
  end
  
  def destroy
    @schedule = VaccinationSchedule.find(params[:id])
    if @schedule.destroy
			render :nothing, status: :no_content
		else
		  render_error_payload(:unprocessable_entity, @schedule.errors, status: 422)
		end
  end
  

	def uncompleted_schedules_select_options
		@schedules = VaccinationSchedule
		.with_zones(params[:zone_ids].split(','))
		.with_type_of_campaign(params[:type_of_campaign_id])
		.with_not_completed
		render json: @schedules, each_serializer: Api::V1::VaccinationScheduleSelectSerializer
  end

	private

	def vaccination_schedule_params
		params.require(:vaccination_schedule).permit(
			:type_of_campaign_id,
			:activity,
			:herd_size,
			:zone_id,
			:notes,
			:farmer_id,
			:campaign_id,
			:animal_group,
			:status,
			:number_of_animals_vaccinated,
			:total_charge_for_vaccinations,
			:completion_date,
			:reschedule_date,
			:reschedule_reason
		)
	end
	
end