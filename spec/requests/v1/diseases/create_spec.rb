require 'rails_helper'

RSpec.describe 'POST /api/v1/diseases', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species) { FactoryGirl.create(:species) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:params) {{
		disease: {
			name: 'Kotomiases',
			description: 'Very contagious',
			species_ids: [species.id],
			symptom_ids: [symptom.id]
		}
	}}
	before {
		post '/api/v1/diseases',
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'creates disease' do
		expect(response.status).to eq(200)
		expect(response.parsed_body.class).to eq(Hash)
	end
end