class Api::V1::CommissionSerializer < Api::BaseSerializer
	attributes :id, :amount, :payment_fee, :farmer_id, :created_at, :updated_at, :type_of_payment

	def farmer_id
		# user find_by to avoid triggering :not_found
		payment = Payment.find_by(id: object.payment_id)
		subscription = Subscription.find_by(id: payment.try(:subscription_id))
		subscription.try(:farmer_id)
	end

	def payment_fee
		payment = Payment.find_by(id: object.payment_id)
		payment.try(:payment_fee)
  end
  
  def type_of_payment
    payment = Payment.find_by(id: object.payment_id)
		payment.try(:item)
  end
  
end