require 'rails_helper'

RSpec.describe 'POST /api/v1/sessions', type: :request do
	let(:params) {{
		data: {
			email: 'niinyarko@yahoo.com',
			password: '123456'
		}
	}}
	before {
		FactoryGirl.create(:user, email: 'niinyarko@yahoo.com', password: '123456')
		post '/api/v1/sessions',
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
		}
	}

	it 'logs in user and returns ACCESS-TOKEN' do
		expect(response.status).to eq(200)
		expect(response.parsed_body.class).to eq(Hash)
		expect(response.headers['ACCESS-TOKEN']).not_to be nil
	end
end