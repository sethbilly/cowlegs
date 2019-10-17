require 'rails_helper'
require 'faker'

RSpec.describe 'GET /api/v1/my_cases/:time_stamp', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species) { FactoryGirl.create(:species) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:time_stamp) { Date.today.last_month }
	before {
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
		get "/api/v1/my_cases/#{time_stamp}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when time_stamp is older' do
		it 'returns cases newer than the time_stamp' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to be > 0
		end
	end

	context 'when time_stamp is newer than last case record' do
		let(:time_stamp) { (Time.now + 10).iso8601 }
		it 'returns zero cases' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to eq(0)
		end
	end
end