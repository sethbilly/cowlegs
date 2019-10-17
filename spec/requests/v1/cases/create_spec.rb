require 'rails_helper'
require 'faker'

RSpec.describe 'POST /api/v1/cases', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:symptom) { FactoryGirl.create(:symptom) }
	let(:params) {{}}
	before {
		post '/api/v1/cases',
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	context 'when type_of_case is not present' do
		let(:params) {{
			pictures: ['http://s3.images.com'],
			location: { address: 'James Town', lat: '323323', lng: '232332' },
			species: Faker::Name.name,
			symptom_ids: [symptom.id],
			community: 'Jamestown',
			age: 'Adult',
			sex: 'Female',
			system: 'Beef',
			number_dead: Faker::Number.digit,
			number_at_risk: Faker::Number.digit,
			number_examined: Faker::Number.digit,
			measures_adopted: 'Vaccination',
			basis_for_diagnosis: ['Rumour'],
		}}
		it 'returns error' do
			expect(response.status).to eq(422)
			expect(response.parsed_body['errors']).to include("type_of_case should be 'active' or 'passive'")
		end
	end

	context 'when case is an active case' do
		let(:params) {{
			pictures: ['http://s3.images.com'],
			location: { address: 'James Town', lat: '323323', lng: '232332' },
			species: Faker::Name.name,
			symptom_ids: [symptom.id],
			type_of_case: 'active',
			age: 'Adult',
			sex: 'Female',
			system: 'Beef',
			community: 'Jamestown',
			number_dead: Faker::Number.digit,
			number_at_risk: Faker::Number.digit,
			number_examined: Faker::Number.digit,
			measures_adopted: 'Vaccination',
			basis_for_diagnosis: ['Clinical history'],
		}}
		it 'creates active case' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['species_id']).not_to be nil
			expect(response.parsed_body['species']).to eq(params[:species].downcase)
		end
	end

	context 'status is left from params' do
		let(:params) {{
			pictures: ['http://s3.images.com'],
			location: { address: 'James Town', lat: '323323', lng: '232332' },
			species: Faker::Name.name,
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
		}}
		it 'sets case status to draft' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['status']).to eq('draft')
		end
	end

	context 'status is final' do
		let(:params) {{
			pictures: ['http://s3.images.com'],
			location: { address: 'James Town', lat: '323323', lng: '232332' },
			species: Faker::Name.name,
			symptom_ids: [symptom.id],
			type_of_case: 'active',
			age: Faker::Number.digit,
			sex: 'Female',
			system: 'Beef',
			community: 'Jamestown',
			number_dead: Faker::Number.digit,
			number_at_risk: Faker::Number.digit,
			number_examined: Faker::Number.digit,
			measures_adopted: 'Vaccination',
			status: 'final'
		}}
		it 'sets case status to final' do
			expect(response.status).to eq(200)
			expect(response.parsed_body.class).to eq(Hash)
			expect(response.parsed_body['status']).to eq('final')
		end
	end

	context 'when case is a passive case' do
	end
end