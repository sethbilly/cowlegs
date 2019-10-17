require 'rails_helper'
require 'faker'

RSpec.describe 'PATCH /api/v1/cases/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species) { FactoryGirl.create(:species) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:params) {{
		species: Faker::Name.name
	}}
	let(:case_record) {
		user.cases.create!({
			pictures: ['http://s3.images.com'],
			location: { address: 'James Town', lat: '323323', lng: '232332' },
			species_id: species.id,
			symptom_ids: [symptom.id],
			type_of_case: 'active',
			age: Faker::Number.digit,
			sex: 'Female',
			system: 'Beef',
			community: 'Jamestown',
			number_dead: Faker::Number.digit,
			number_at_risk: Faker::Number.digit,
			number_examined: Faker::Number.digit,
			measures_adopted: 'Vaccination'
		})
	}
	before {
		patch "/api/v1/cases/#{case_record.id}",
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when species is different' do
		it 'updates case species' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['species']).to eq(params[:species].downcase)
		end
	end
	context 'when system is different' do
		let(:params) {{
			system: 'Traditional'
		}}
		it 'updates case system' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['system']).to eq(params[:system])
		end
	end
	context 'when pictures is different' do
		let(:params) {{
			pictures: ['http://s3.images.filename.com']
		}}
		it 'updatess case pictures' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['pictures'].first).to eq(params[:pictures].first)
		end
	end
end