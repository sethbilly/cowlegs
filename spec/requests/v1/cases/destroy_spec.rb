require 'rails_helper'
require 'faker'

RSpec.describe 'DELETE /api/v1/cases/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species) { FactoryGirl.create(:species) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:case_record) {
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
	}
	before {
		delete "/api/v1/cases/#{case_record.id}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'destroys case' do
		expect(response.status).to eq(204)
	end
end