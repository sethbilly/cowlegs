require 'rails_helper'
require 'faker'

RSpec.describe 'GET /api/v1/cases', type: :request do
	let(:user) { FactoryGirl.create(:user, role: 'admin') }
	let(:species) { FactoryGirl.create(:species) }
	let(:organization) { FactoryGirl.create(:organization) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	before {
		user.organization_ids = organization.id
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
		get '/api/v1/cases',
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
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to be > 0
		end
	end

	context 'when user is manager' do
		let(:user) { FactoryGirl.create(:user, role: 'manager') }
		it 'returns list of cases created by manager organization users' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to be > 0
		end
	end
end