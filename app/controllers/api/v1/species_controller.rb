class Api::V1::SpeciesController < ApplicationController
	before_action :authenticate_user!, except: :index

	def index
		@species = Species.all
		render json:
		        @species,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::SpeciesSerializer,
		      adapter: :attributes
	end

	def create
		@species = Species.new(species_params)
		if @species.save
		  render json:
		          @species,
		        serializer: Api::V1::SpeciesSerializer,
		        adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params.fetch(:species),
		    errors: @species.errors
		  )
		end
	end

	def update
		@species = Species.find(params[:id])
		if @species.update(species_params)
		  render json:
		          @species,
		        serializer: Api::V1::SpeciesSerializer,
		        adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params.fetch(:species),
		    errors: @species.errors
		  )
		end
	end

	def destroy
		@species = Species.find(params[:id])
		if @species.destroy
		  render :nothing, status: :no_content
		else
		  head 422
		end
	end

	private

	def species_params
	  params.require(:species).permit(:name)
	end
end