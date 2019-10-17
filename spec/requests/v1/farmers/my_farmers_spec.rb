require 'rails_helper'
require 'faker'

RSpec.describe 'GET /api/v1/my_farmers/:time_stamp', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:time_stamp) { Date.today.last_month }
	let(:farmer) {FactoryGirl.create(:farmer)}
	before {
		farmer.user_ids = user.id
		get "/api/v1/my_farmers/#{time_stamp}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when time_stamp is older' do
		it 'returns farmers newer than the time_stamp' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to be > 0
		end
	end

	context 'when time_stamp is newer than last farmer record' do
		let(:time_stamp) { (Time.now + 10).iso8601 }
		it 'returns zero cases' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to eq(0)
		end
	end
end