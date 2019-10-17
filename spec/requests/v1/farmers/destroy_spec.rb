require 'rails_helper'

RSpec.describe 'DELETE /api/v1/farmers/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:farmer) {FactoryGirl.create(:farmer)}
	before {
		delete "/api/v1/farmers/#{farmer.id}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'destroys farmer' do
		expect(response.status).to eq(204)
	end
end