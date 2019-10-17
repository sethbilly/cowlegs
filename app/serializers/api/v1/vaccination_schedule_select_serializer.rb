class Api::V1::VaccinationScheduleSelectSerializer < Api::BaseSerializer
  attributes :key, :text, :value

  def key
    object.id
  end

  def text
    # lets not trigger 404
    type_of_campaign = TypeOfCampaign.find_by_id(object.type_of_campaign_id)
    if type_of_campaign.nil?
      return object.created_at.strftime("%Y-%m-%d")
    end
    "#{type_of_campaign.type_of_campaign}-#{type_of_campaign.code}-#{object.created_at.strftime("%Y-%m-%d")}"
  end

  def value
    object.id
  end
end