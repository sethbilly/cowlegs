require 'rails_helper'
require 'faker'

RSpec.describe 'GET /api/v1/analytics/manager_dashboard_stats', type: :request do
	let(:user) { FactoryGirl.create(:user, role: 'manager') }
	let(:species) { FactoryGirl.create(:species) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:organization) { FactoryGirl.create(:organization) }
	before {
		user.organization_ids = organization.id
		User.create!({
			email: Faker::Internet.email,
			password: Faker::Internet.password,
		  first_name: Faker::Name.first_name,
		  last_name: Faker::Name.last_name,
		  phone_number: Faker::PhoneNumber.cell_phone,
		  location: { address: 'James Town', lat: '323323', lng: '232332' },
		  role: 1,
		  organization_ids: organization.id
		})
		user.cases.create!({
			pictures: ['http://s3.images.com'],
			location: { address: 'James Town', lat: '323323', lng: '232332' },
			species_id: species.id,
			symptom_ids: [symptom.id],
			type_of_case: 'active',
			age: Faker::Number.digit,
			sex: 'Female',
			system: 'Beef',
			community: 'Jamestown',
			number_dead: Faker::Number.digit,
			number_at_risk: Faker::Number.digit,
			number_examined: Faker::Number.digit,
			measures_adopted: 'Vaccination'
		})
		get '/api/v1/analytics/manager_dashboard_stats',
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when user is manager' do
		it 'return count of stats' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['total_users']).to eq(2)
			expect(response.parsed_body['total_cases']).to eq(1)
		end
	end

	context 'when user is admin' do
		let(:user) { FactoryGirl.create(:user, role: 'admin') }
		it 'return zero count of stats' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body.length).to eq(0)
		end
	end
end