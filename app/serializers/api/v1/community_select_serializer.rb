class Api::V1::CommunitySelectSerializer < Api::BaseSerializer
  attributes :key, :text, :value

  def key
    object.id
  end

  def text
    object.address
  end

  def value
    object.id
  end
end
