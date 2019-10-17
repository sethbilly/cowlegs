# https://medium.com/@goncalvesjoao/rails-devise-jwt-and-the-forgotten-warden-67cfcf8a0b73
# https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one
# https://rubyplus.com/articles/2241-Authentication-from-Scratch-Password-Reset-Feature
# http://www.eq8.eu/blogs/30-native-rspec-json-api-testing
# https://www.youtube.com/watch?v=UggLiefD02Q
# https://www.youtube.com/watch?v=AQ-Vf157Ju8

require 'will_paginate/array'

class Api::V1::CasesController < ApplicationController
	before_action :authenticate_user!

	def index
		# paginate needs an ActiveRecord::Relation object
		@cases = Case.none
		if current_user.role == 'admin'
			@cases = Case.all
		elsif current_user.role == 'manager'
			organization = current_user.organizations.first
			organization.users.find_each do |user|
				user.cases.find_each do |caseItem|
					@cases << caseItem
				end
			end
		end
		paginate json: @cases
	end

	def show
		@case = Case.find(params[:id])
		render json:
		        @case,
		      serializer: Api::V1::CaseSerializer,
		      adapter: :attributes
	end

	def create
		@case = current_user.cases.build(case_params.except(:species, :pictures))
		if case_params[:pictures]
			if case_params[:pictures].first.class == String
				@case.pictures = case_params[:pictures]
			elsif case_params[:pictures].first.class == ActionDispatch::Http::UploadedFile
				s3 = Aws::S3::Resource.new
				pictureUrls = []
				case_params[:pictures].each do |picture|
		      obj = s3.bucket(ENV['S3_BUCKET']).object(picture.original_filename)
		      if obj.upload_file(picture.tempfile.path)
		        pictureUrls << obj.public_url
		      end
		    end
		    @case.pictures = pictureUrls
			end
		end
		if case_params[:species]
			@species = Species.find_by_name(case_params[:species].downcase)
			if @species
				@case.species_id = @species.id
			else
				@species = Species.create(name: case_params[:species])
				@case.species_id = @species.id
			end
		else
			api_error(
			  status: 422,
			  data: params,
			  errors: ['species is required']
			)
			return
		end
		if @case.save
		  render json:
		          @case,
		        serializer: Api::V1::CaseSerializer,
		        adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params,
		    errors: @case.errors
		  )
		end
	end

	def update
		@case = Case.find(params[:id])
		if case_params[:species]
			@species = Species.find_by_name(case_params[:species].downcase)
			if @species
				@case.attributes = case_params.except(:species, :pictures).merge(species_id: @species.id)
			else
				@species = Species.create(name: case_params[:species])
				@case.attributes = case_params.except(:species, :pictures).merge(species_id: @species.id)
			end
		else
			@case.attributes = case_params.except(:species, :pictures)
		end
		if case_params[:pictures]
			if case_params[:pictures].first.class == String
				@case.attributes = { pictures: case_params[:pictures] }
			elsif case_params[:pictures].first.class == ActionDispatch::Http::UploadedFile
				s3 = Aws::S3::Resource.new
				pictureUrls = []
				case_params[:pictures].each do |picture|
		      obj = s3.bucket(ENV['S3_BUCKET']).object(picture.original_filename)
		      if obj.upload_file(picture.tempfile.path)
		        pictureUrls << obj.public_url
		      end
		    end
		    @case.attributes = { pictures: pictureUrls }
			end
		end
		if @case.save
		  render json:
		          @case,
		        serializer: Api::V1::CaseSerializer,
		        adapter: :attributes
		else
		  api_error(
		    status: 422,
		    data: params,
		    errors: @case.errors
		  )
		end
	end

	def destroy
		@case = Case.find(params[:id])
		if @case.destroy
		  render :nothing, status: :no_content
		else
		  head 422
		end
	end

	def my_cases
		@cases = []
		current_user.cases.find_each do |case_item|
		  if Time.parse(case_item.created_at.to_s) > Time.parse(my_cases_params[:time_stamp])
		    @cases << case_item
		  end
		end
		render json:
		           @cases,
		         serializer: ActiveModel::Serializer::CollectionSerializer,
		         each_serializer: Api::V1::CaseSerializer,
		         adapter: :attributes
	end

	def filtered_cases
		@cases = []
		filter = params[:filter]
		case filter
		when REPORTED_CASES_FROM_THIS_WEEK
			if current_user.role == 'admin'
				@cases = Case.from_this_week
			elsif current_user.role == 'manager'
				organization = current_user.organizations.first
				organization.users.find_each do |user|
					user.cases.where('created_at >= ?',
              Date.today.beginning_of_week).find_each do |caseItem|
						@cases << caseItem
					end
				end
			end
		when REPORTED_CASES_FROM_LAST_WEEK
			if current_user.role == 'admin'
				@cases = Case.from_last_week
			elsif current_user.role == 'manager'
				organization = current_user.organizations.first
				organization.users.find_each do |user|
					user.cases.where('created_at >= ?', 
              Date.today.last_week.beginning_of_week).find_each do |caseItem|
						@cases << caseItem
					end
				end
			end
		when REPORTED_CASES_FROM_THIS_MONTH
			if current_user.role == 'admin'
				@cases = Case.from_this_month
			elsif current_user.role == 'manager'
				organization = current_user.organizations.first
				organization.users.find_each do |user|
					user.cases.where('created_at >= ?',
              Date.today.beginning_of_month).find_each do |caseItem|
						@cases << caseItem
					end
				end
			end
		when REPORTED_CASES_FROM_LAST_MONTH
			if current_user.role == 'admin'
				@cases = Case.from_last_month
			elsif current_user.role == 'manager'
				organization = current_user.organizations.first
				organization.users.find_each do |user|
					user.cases.where( 'created_at >= ?', 
              Date.today.last_month.beginning_of_month).find_each do |caseItem|
						@cases << caseItem
					end
				end
			end
		when REPORTED_CASES_FOR_LAST_SIX_MONTHS
			# {x: 1, y: 10},
			total_for_last_six_months = 0
			total_for_last_five_months = 0
			total_for_last_four_months = 0
			total_for_last_three_months = 0
			total_for_last_two_months = 0
			total_for_last_month = 0
			if current_user.role == 'admin'
				total_for_last_six_months = Case.where('created_at >= ? AND created_at < ?', 
              Date.today.months_ago(6).beginning_of_month, 
              Date.today.months_ago(5).beginning_of_month ).size

				total_for_last_five_months = Case.where('created_at >= ? AND created_at < ?', 
              Date.today.months_ago(5).beginning_of_month, 
              Date.today.months_ago(4).beginning_of_month ).size

				total_for_last_four_months = Case.where('created_at >= ? AND created_at < ?', 
              Date.today.months_ago(4).beginning_of_month, 
              Date.today.months_ago(3).beginning_of_month ).size

				total_for_last_three_months = Case.where('created_at >= ? AND created_at < ?', 
              Date.today.months_ago(3).beginning_of_month, 
              Date.today.months_ago(2).beginning_of_month ).size

				total_for_last_two_months = Case.where('created_at >= ? AND created_at < ?', 
              Date.today.months_ago(2).beginning_of_month, 
              Date.today.months_ago(1).beginning_of_month ).size

				total_for_last_month = Case.where('created_at >= ? AND created_at < ?', 
              Date.today.last_month.beginning_of_month, 
              Date.today.beginning_of_month).size

			elsif current_user.role == 'manager'
				organization = current_user.organizations.first
				organization.users.find_each do |user|
					total_for_last_six_months = user.cases.where('created_at >= ? AND created_at < ?', 
	              Date.today.months_ago(6).beginning_of_month, 
	              Date.today.months_ago(5).beginning_of_month ).size

					total_for_last_five_months = user.cases.where('created_at >= ? AND created_at < ?', 
	              Date.today.months_ago(5).beginning_of_month, 
	              Date.today.months_ago(4).beginning_of_month ).size

					total_for_last_four_months = user.cases.where('created_at >= ? AND created_at < ?', 
	              Date.today.months_ago(4).beginning_of_month, 
	              Date.today.months_ago(3).beginning_of_month ).size

					total_for_last_three_months = user.cases.where('created_at >= ? AND created_at < ?', 
	              Date.today.months_ago(3).beginning_of_month, 
	              Date.today.months_ago(2).beginning_of_month ).size

					total_for_last_two_months = user.cases.where('created_at >= ? AND created_at < ?', 
	              Date.today.months_ago(2).beginning_of_month, 
	              Date.today.months_ago(1).beginning_of_month ).size

					total_for_last_month = user.cases.where('created_at >= ? AND created_at < ?', 
	              Date.today.last_month.beginning_of_month, 
	              Date.today.beginning_of_month).size
				end
			end
			render json: [
					{"#{Date::MONTHNAMES[Date.today.months_ago(6).month]}": total_for_last_six_months},
					{"#{Date::MONTHNAMES[Date.today.months_ago(5).month]}": total_for_last_five_months},
					{"#{Date::MONTHNAMES[Date.today.months_ago(4).month]}": total_for_last_four_months},
					{"#{Date::MONTHNAMES[Date.today.months_ago(3).month]}": total_for_last_three_months},
					{"#{Date::MONTHNAMES[Date.today.months_ago(2).month]}": total_for_last_two_months},
					{"#{Date::MONTHNAMES[Date.today.last_month.month]}": total_for_last_month}
				]
			return
		end
		render json:
		        @cases,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::CaseSerializer,
		      adapter: :attributes
	end

	private

	def case_params
	  load_params = params.permit(
	  	:zone_id,
	  	:district_id,
	  	:name_of_laboratory,
	  	:community,
	  	:age,
	  	:sex,
	  	:system,
	  	:number_dead,
	  	:number_examined,
	  	:number_at_risk,
	  	:measures_adopted,
	  	:epidemiology,
	  	:tentative_diagnosis,
	  	:differential_diagnosis,
	  	:samples_sent_to_lab,
	  	:date_of_sample_submission,
	  	:details_of_diagnosis,
	  	:status,
	    :species,
	    pictures: [],
	    symptom_ids: [],
	    basis_for_diagnosis: []
	  )
	  load_params[:location] = params[:location] if params[:location]
	  load_params.permit!
	end

	def my_cases_params
		params.require(:case).permit(
			:time_stamp
		)
	end

end