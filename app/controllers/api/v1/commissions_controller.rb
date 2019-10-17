class Api::V1::CommissionsController < ApplicationController
	before_action :authenticate_user!

	def my_commissions
		@commissions = current_user.commissions
		render json:
		        @commissions,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::CommissionSerializer,
		      adapter: :attributes
	end
end

# VaccinationSchedule.create!({
# 	farmer_id: 15, 
# 	zone_id: 344,
# 	herd_size: 10,
# 	type_of_campaign_id: 4,
# 	activity: 'vaccination',
# 	animal_group: 'Cattle'
# })

# AnimalTag.create!({
# 	farmer_id: 15,
# 	bid_number: "dsdsdsdssdsd",
# 	tag_number: "2343534acsdd34343",
# 	age: 2,
# 	sex: 'Male',
# 	breed: 'Sokoto',
# 	type_of_animal: 'Cattle',
# })

# AnimalTagVaccination.create!({
# 	animal_tag_id: 1,
# 	type_of_vaccination: "PPR",
# 	user_id: 57
# })