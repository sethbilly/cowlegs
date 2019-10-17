require 'rails_helper'

RSpec.describe 'PATCH /api/v1/symptoms/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:params) {{
		symptom: {
			description: 'updated symptom'
		}
	}}
	before {
		patch "/api/v1/symptoms/#{symptom.id}",
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'updates symptom description' do
		expect(response.status).to eq(200)
		expect(response.parsed_body.class).to eq(Hash)
		expect(response.parsed_body['description']).to eq(params[:symptom][:description])
	end
end