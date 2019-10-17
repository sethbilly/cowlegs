class Api::V1::SubscriptionsController < ApplicationController
	include Swagger::Blocks
	before_action :authenticate_user!

	swagger_path '/v1/subscriptions' do
	  operation :post do
	    extend SwaggerResponses::ModelCreateError
	    key :description, "Pays subscription for a farmer. This will charge a farmer's e-wallet account using the farmer's e-wallet ID. Upon successfull charge farmer's subscription is renewed or created."
	    key :operationId, 'PaySubscription'

	    key :tags, [
	      'Farmer'
	    ]

	    parameter do
	      key :name, :data
	      key :in, :body
	      key :description, 'Root data object'
	      key :required, true
	      key :type, :object
	      schema do
	        key :'$ref', :PaySubscriptionInput
	      end
	    end

	    response 200 do
	      key :description, 'Returns payment response'
	      schema do
	        key :'$ref', :PaySubscriptionResponse
	      end
	    end
	  end
	end
	def create
		pricing_plan = PricingPlan.find_by_name!(subscription_params[:pricing_plan])
		farmer = Farmer.find(subscription_params[:farmer_id])
		duration = subscription_params[:duration]
		payment_fee = subscription_params[:payment_fee]

		tc = (duration * pricing_plan.price).to_i

		if payment_fee.nil?
			payment_fee = tc
		end

		subscription = Subscription.new(
			farmer_id: subscription_params[:farmer_id],
			user_id: current_user.id,
			pricing_plan_id: pricing_plan.id,
			duration: duration,
			expires_on: Time.now + duration.month,
			total_cost_of_subscription: tc,
			total_amount_paid: payment_fee,
			total_amount_due: tc - payment_fee,
			type_of_subscription: farmer.subscriptions.count == 0 ? 0 : 1
		)

		payment = subscription.payments.build(
			payment_fee: payment_fee,
			payment_method: subscription_params[:payment_method],
			item: 'subscription'
		)
		payment.farmer_payments.build(farmer_id: subscription.farmer_id)
		payment.user_payments.build(user_id: current_user.id)

		if subscription.save
			render json:
			        subscription,
			      serializer: Api::V1::SubscriptionSerializer,
			      adapter: :attributes
		else
			render_error_payload(:unprocessable_entity, subscription.errors, status: 422)
		end
	end

	def updated_subscriptions_list
		@subscriptions = []
		Subscription.find_each do |subscription|
			if Time.parse(subscription.updated_at.to_s) > Time.parse(subscription_params[:time_stamp])
			  @subscriptions << subscription
			end
		end
		render json:
		        @subscriptions,
		      serializer: ActiveModel::Serializer::CollectionSerializer,
		      each_Serializer: Api::V1::SubscriptionSerializer,
		      adapter: :attributes
	end

	private

	def subscription_params
		params.require(:subscription).permit(
			:payment_fee,
			:time_stamp,
			:payment_method,
			:duration,
			:pricing_plan,
			:farmer_id
		)
	end
end