class Api::V1::DistrictSerializer < Api::BaseSerializer
	attributes :id, :name, :zones, :created_at, :updated_at

  def zones
    zones = []
    object.zones.find_each do |zone|
      zones.push({
        id: zone.id,
        name: zone.name,
        code: zone.code,
        communities: zone.communities
      })
    end
    zones
	end
end