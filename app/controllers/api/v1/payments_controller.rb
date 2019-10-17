class  Api::V1::PaymentsController < ApplicationController
	before_action :authenticate_user!

	def create
		@subscription = Subscription.find(payment_params[:subscription_id])
		@payment = Payment.new(payment_params)
		@payment.farmer_payments.build(farmer_id: @subscription.farmer_id)
		@payment.user_payments.build(user_id: current_user.id)
		if @payment.save
			tp = @subscription.total_amount_paid + @payment.payment_fee
			@subscription.update({
				total_amount_paid: tp,
				total_amount_due: @subscription.total_cost_of_subscription - tp
			})
			render json:
			        @subscription,
			      serializer: Api::V1::SubscriptionSerializer,
			      adapter: :attributes
		else
			render_error_payload(:unprocessable_entity, @payment.errors, status: 422)
		end
	end

	def total_collections
		if current_user.is_admin?
			render json: { total: Payment.sum(:payment_fee) }
		else	
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
			return
		end
	end
	

	def revenue_collections
		if current_user.is_admin?
			paginate json: Payment.all.order(created_at: :desc)
		else	
			render_error_payload(:insufficient_permission, nil, status: :forbidden)
			return
		end
	end
	
	private

	def payment_params
		params.require(:payment).permit(
			:subscription_id,
			:payment_method,
			:payment_fee,
			:item
		)
	end
end

# Payment.find_each do |payment|
# 	payment.item = 'subscription'
# 	subscription = Subscription.find_by_id(payment.subscription_id)
# 	unless subscription.nil?
# 		payment.user_payments.build(user_id: subscription.user_id)
# 	end
# 	payment.save
# end