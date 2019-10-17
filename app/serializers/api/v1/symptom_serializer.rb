class Api::V1::SymptomSerializer < Api::BaseSerializer
  attributes :id, :description, :created_at, :updated_at
end