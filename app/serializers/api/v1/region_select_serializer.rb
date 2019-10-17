class Api::V1::RegionSelectSerializer < Api::BaseSerializer
  attributes :key, :text, :value

  def key
    object.id
  end

  def text
    object.name
  end

  def value
    object.id
  end
end