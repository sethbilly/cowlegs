require 'rails_helper'

RSpec.describe 'POST /api/v1/symptoms', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:params) {{
		symptom: {
			description: 'new symptom'
		}
	}}
	before {
		post '/api/v1/symptoms',
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'creates symptoms' do
		expect(response.status).to eq(200)
		expect(response.parsed_body.class).to eq(Hash)
	end
end