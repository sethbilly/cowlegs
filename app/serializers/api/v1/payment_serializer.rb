class Api::V1::PaymentSerializer < Api::BaseSerializer
	attributes :id, :payment_fee, :item, :payment_method, :created_at

	has_many :farmers
  has_many :users
end