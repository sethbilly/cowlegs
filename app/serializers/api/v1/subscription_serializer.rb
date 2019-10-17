class Api::V1::SubscriptionSerializer < Api::BaseSerializer
	attributes :id, :farmer_id, :expires_on, :duration, :total_cost_of_subscription,
		:total_amount_paid, :total_amount_due, :created_at, :updated_at
end