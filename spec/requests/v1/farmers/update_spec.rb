require 'rails_helper'
require 'faker'

RSpec.describe 'PATCH /api/v1/farmers/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:farmer) {FactoryGirl.create(:farmer)}
	let(:params) {{
		sex: 'M',
	}}
	before {
		patch "/api/v1/farmers/#{farmer.id}",
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'sex is F' do
		let(:params) {{
			sex: 'F',
		}}
		it 'updates farmer sex' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['sex']).to eq(params[:sex])
		end
	end
end