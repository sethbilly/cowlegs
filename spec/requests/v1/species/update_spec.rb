require 'rails_helper'

RSpec.describe 'PATCH /api/v1/species', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species) { FactoryGirl.create(:species) }
	let(:params) {{
		name: 'cattle'
	}}
	before {
		patch "/api/v1/species/#{species.id}",
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'updates species' do
		expect(response.status).to eq(200)
		expect(response.parsed_body.class).to eq(Hash)
		expect(response.parsed_body['name']).to eq(params[:name])
	end
end