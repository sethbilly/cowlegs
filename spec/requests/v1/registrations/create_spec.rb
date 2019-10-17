require 'rails_helper'
require 'faker'

RSpec.describe 'POST /api/v1/registrations', type: :request do
	let(:params) {{
		user: {
			email: Faker::Internet.email,
			password: Faker::Internet.password,
		  first_name: Faker::Name.first_name,
		  last_name: Faker::Name.last_name,
		  phone_number: Faker::PhoneNumber.cell_phone
		}
	}}
	before {
		post '/api/v1/registrations',
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json'
		}
	}

	it 'returns user ACCESS-TOKEN in response header' do
		expect(response.headers['ACCESS-TOKEN']).not_to be nil
	end

	context 'when role is omitted' do
		it 'creates a user with clw default role' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['role']).to eq('clw')
		end
	end

	context 'when user is a manager and params has organization' do
		let(:params) {{
			user: {
				email: Faker::Internet.email,
				password: Faker::Internet.password,
			  first_name: Faker::Name.first_name,
			  last_name: Faker::Name.last_name,
			  phone_number: Faker::PhoneNumber.cell_phone,
			  location: { address: 'James Town', lat: '323323', lng: '232332' },
			  role: 2,
			  organization: {
			  	name: Faker::Name.name,
			  	description: Faker::Lorem.sentence,
			  	postal_address: Faker::Address.postcode,
			  	number_of_staff: Faker::Number.digit,
			  	region: Faker::Address.state,
			  	district: Faker::Address.city
			  }
			}
		}}
		it 'creates a user with manager role and organization' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['role']).to eq('manager')
			expect(response.parsed_body['organizations'].class).to eq(Array)
			expect(response.parsed_body['organizations'].size).to be > 0
		end
	end

	context 'when owner params is present' do
		let(:organization) {FactoryGirl.create(:organization)}
		let(:params) {{
			user: {
				email: Faker::Internet.email,
				password: Faker::Internet.password,
			  first_name: Faker::Name.first_name,
			  last_name: Faker::Name.last_name,
			  phone_number: Faker::PhoneNumber.cell_phone,
			  location: { address: 'James Town', lat: '323323', lng: '232332' },
			  owner: {
			  	organization_id: organization.id,
			  }
			}
		}}

		it 'creates user with organization' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['role']).to eq('clw')
			expect(response.parsed_body['organizations'].class).to eq(Array)
			expect(response.parsed_body['organizations'].size).to be > 0
		end
	end
end