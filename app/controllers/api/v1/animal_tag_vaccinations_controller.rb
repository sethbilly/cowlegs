class Api::V1::AnimalTagVaccinationsController < ApplicationController
	before_action :authenticate_user!

	def create
    @vaccination = AnimalTagVaccination.new(vaccination_params)
    if @vaccination.save
      render json:
		        @vaccination,
		      serializer: Api::V1::AnimalTagVaccinationSerializer,
		      adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @vaccination.errors, status: 422) 
    end
  end
  
  private

  def vaccination_params
    params.require(:vaccination).permit(
      :user_id,
      :animal_tag_id,
      :type_of_vaccination,
      :notes
	  )
  end
  
end