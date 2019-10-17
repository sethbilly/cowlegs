class Api::V1::AnimalTagsController < ApplicationController
	before_action :authenticate_user!

	def create
    @tag = AnimalTag.new(animal_tags_params)
    if @tag.save
      render json:
		        @tag,
		      serializer: Api::V1::AnimalTagSerializer,
		      adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @tag.errors, status: 422) 
    end
  end
  
  def update
    @tag = AnimalTag.find(params[:id])
    if @tag.update(animal_tags_params)
      render json:
		        @tag,
		      serializer: Api::V1::AnimalTagSerializer,
          adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @tag.errors, status: 422) 
    end
  end
  
  
  private

  def animal_tags_params
    params.require(:tag).permit(
      :farmer_id,
      :bid_number,
      :tag_number,
      :age,
      :sex,
      :notes,
      :breed,
      :type_of_animal
	  )
  end
  
end