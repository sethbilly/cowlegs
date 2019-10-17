require 'rails_helper'

RSpec.describe 'PATCH /api/v1/diseases/:id', type: :request do
	let(:user) { FactoryGirl.create(:user) }
	let(:species1) { FactoryGirl.create(:species) }
	let(:species2) { FactoryGirl.create(:species) }
	let(:disease) { FactoryGirl.create(:disease, species_ids: [species1.id]) }
	let(:params) {{
		disease: {
			name: 'Kalabosemiases'
		}
	}}
	before {
		patch "/api/v1/diseases/#{disease.id}",
		params: params.to_json,
		headers: {
			'CONTENT_TYPE': 'application/json',
			'ACCEPT': 'application/json',
			'AUTHORIZATION': "Bearer #{user.create_new_jwt_token}"
		}
	}

	it 'updates disease name' do
		expect(response.status).to eq(200)
		expect(response.parsed_body['name']).to eq(params[:disease][:name])
	end

	context 'when new set of species_ids is provided' do
		let(:params) {{
			disease: {
				species_ids: [species2.id]
			}
		}}
		it 'updates species_ids references' do
			expect(response.status).to eq(200)
			expect(disease.species_ids.first).not_to eq(response.parsed_body['species'].first['id'])
		end
	end
end