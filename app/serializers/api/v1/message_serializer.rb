class Api::V1::MessageSerializer < Api::BaseSerializer
  attributes :id, :title, :voice_id, :message_id, :created_at, :updated_at
end