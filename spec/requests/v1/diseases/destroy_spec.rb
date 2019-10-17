require 'rails_helper'

RSpec.describe 'DELETE /api/v1/diseases/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:disease) { FactoryGirl.create(:disease) }
	before {
		delete "/api/v1/diseases/#{disease.id}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'destroys disease' do
		expect(response.status).to eq(204)
	end
end