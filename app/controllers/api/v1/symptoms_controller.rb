class Api::V1::SymptomsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :symptoms_list]
	def index
		@symptoms = Symptom.all
		render json:
		        @symptoms,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::SymptomSerializer,
		      adapter: :attributes
	end

	def create
		@symptom = Symptom.new(symptom_params)
		if @symptom.save
		  render json:
		          @symptom,
		        serializer: Api::V1::SymptomSerializer,
		        adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params.fetch(:symptom),
		    errors: @symptom.errors
		  )
		end
	end

	def update
		@symptom = Symptom.find(params[:id])
		if @symptom.update(symptom_params)
		  render json:
		          @symptom,
		        serializer: Api::V1::SymptomSerializer,
		        adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params.fetch(:symptom),
		    errors: @symptom.errors
		  )
		end
	end

	def destroy
		@symptom = Symptom.find(params[:id])
		if @symptom.destroy
		  render :nothing, status: :no_content
		else
		  head 422
		end
	end

	private

	def symptom_params
	  params.require(:symptom).permit(
	  	:description
	  )
	end
end