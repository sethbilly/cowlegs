require 'rails_helper'

RSpec.describe 'GET /api/v1/species', type: :request do
	before {
		FactoryGirl.create(:species)
		get '/api/v1/species',
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json'
		}
	}

	it 'returns list of species' do
		expect(response.status).to eq(200)
		expect(response.parsed_body.class).to eq(Array)
		expect(response.parsed_body.size).to be > 0
	end
end