 class Api::V1::DiseasesController < ApplicationController
	before_action :authenticate_user!, except: :index

	def index
		@diseases = Disease.all
		render json:
		        @diseases,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::DiseaseSerializer,
		      adapter: :attributes
	end

	def create
		@disease = Disease.new(disease_params)
		if @disease.save
			render json:
							@disease,
						serializer: Api::V1::DiseaseSerializer,
						adapter: :attributes
		else
			api_error(
			  status: 422,
			  data: params.fetch(:disease),
			  errors: @disease.errors
			)
		end
	end

	def update
		@disease = Disease.find(params[:id])
		if @disease.update(disease_params)
		  render json:
		  				@disease,
		  			serializer: Api::V1::DiseaseSerializer,
		  			adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params.fetch(:disease),
		    errors: @disease.errors
		  )
		end
	end

	def destroy
		@disease = Disease.find(params[:id])
		if @disease.destroy
		  render :nothing, status: :no_content
		else
		  head 422
		end
	end

	private

	def disease_params
	  params.require(:disease).permit(
	  	:name,
	  	:description,
	  	species_ids: [],
	  	symptom_ids: []
	  )
	end
end