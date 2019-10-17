class Api::V1::UserSelectSerializer < Api::BaseSerializer
  attributes :key, :text, :value

  def key
    object.id
  end

  def text
    "#{object.first_name} #{object.last_name}"
  end

  def value
    object.id
  end
end