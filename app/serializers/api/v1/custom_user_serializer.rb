class Api::V1::CustomUserSerializer < Api::BaseSerializer
  attributes :id, :slug, :first_name, :last_name, :name
  
  def name
    object.first_name + " " + object.last_name
  end
  
end