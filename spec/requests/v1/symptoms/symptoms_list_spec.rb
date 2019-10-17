require 'rails_helper'

RSpec.describe 'GET /api/v1/symptoms_list/:offset', type: :request do
	let(:offset) {0}
	before {
		FactoryGirl.create(:symptom)
		FactoryGirl.create(:symptom)
		FactoryGirl.create(:symptom)
		FactoryGirl.create(:symptom)
		FactoryGirl.create(:symptom)
		get "/api/v1/symptoms_list/#{offset}",
		params: {},
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json'
		}
	}

	context 'when offset is 0' do
		it 'returns 5 elemnts in the list' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to eq(5)
		end
	end

	context 'when offsets is 2' do
		let(:offset) {2}
		it 'returns 3 elemnts in the list ' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Array)
			expect(response.parsed_body.size).to eq(3)
		end
	end
end