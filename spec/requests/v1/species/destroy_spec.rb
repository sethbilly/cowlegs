require 'rails_helper'

RSpec.describe 'DELETE /api/v1/species/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species) { FactoryGirl.create(:species) }
	before {
		delete "/api/v1/species/#{species.id}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'destroys species' do
		expect(response.status).to eq(204)
	end
end