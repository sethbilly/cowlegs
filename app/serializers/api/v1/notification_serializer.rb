class  Api::V1::NotificationSerializer < Api::BaseSerializer
  attributes( :id, :message_id, :scheduled, :sent )
end