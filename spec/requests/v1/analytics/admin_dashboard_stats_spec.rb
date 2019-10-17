require 'rails_helper'
require 'faker'

RSpec.describe 'GET /api/v1/analytics/admin_dashboard_stats', type: :request do
	let(:user) { FactoryGirl.create(:user, role: 'admin') }
	let(:species) { FactoryGirl.create(:species) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	before {
		FactoryGirl.create(:farmer)
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
		get '/api/v1/analytics/admin_dashboard_stats',
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when user is admin' do
		it 'return all cases' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['total_farmers']).to eq(1)
			expect(response.parsed_body['total_cases']).to eq(1)
		end
	end

	context 'when user is manager' do
		let(:user) { FactoryGirl.create(:user, role: 'manager') }
		it 'return all cases' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body.length).to eq(0)
		end
	end
end