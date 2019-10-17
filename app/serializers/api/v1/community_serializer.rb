class Api::V1::CommunitySerializer < Api::BaseSerializer
	attributes :id, :zone_id, :address, :lat, :lng, :created_at, :updated_at
end