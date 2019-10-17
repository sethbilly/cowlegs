class Api::V1::TypeOfCampaignSelectSerializer < Api::BaseSerializer
  attributes :key, :text, :value

  def key
    object.id
  end

  def text
    object.type_of_campaign
  end

  def value
    object.id
  end
end