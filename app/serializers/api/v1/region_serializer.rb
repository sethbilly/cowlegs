class Api::V1::RegionSerializer < Api::BaseSerializer
	attributes :id, :name, :created_at, :updated_at

	has_many :districts
end