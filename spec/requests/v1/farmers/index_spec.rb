require 'rails_helper'

RSpec.describe 'GET /api/v1/farmers', type: :request do
	let(:user) { FactoryGirl.create(:user, role: 'admin') }
	let(:organization) {FactoryGirl.create(:organization)}
	before {
		user.organization_ids = organization.id
		FactoryGirl.create(:farmer, user_ids: user.id, organization_ids: organization.id)
		get '/api/v1/farmers',
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when user is admin' do
		it 'returns list of farmers' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to be > 0
		end
	end


	context 'when user is not admin' do
		let(:user) { FactoryGirl.create(:user, role: 'manager') }
		it 'returns empty list of farmers' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to eq(0)
		end
	end
end