require 'rails_helper'

RSpec.describe 'DELETE /api/v1/symptoms/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	before {
		delete "/api/v1/symptoms/#{symptom.id}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'destroys symptoms' do
		expect(response.status).to eq(204)
	end
end