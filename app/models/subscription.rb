class Subscription < ApplicationRecord
	include Swagger::Blocks

  belongs_to :farmer
  belongs_to :user
  belongs_to :pricing_plan
  has_many :payments, dependent: :destroy

  enum type_of_subscription: [:new_subscription, :renewal]

  scope :before_this_week, -> {
    where( 'created_at < ?',
            Date.today.beginning_of_week )}
  scope :expired, -> {
    where( 'expires_on < ?',
            Date.today )}
  scope :expired_before_this_week, -> {
    where( 'expires_on < ?',
      Date.today.beginning_of_week )}

  scope :with_type, -> (type) { where type_of_subscription: type }
  scope :with_user, -> (user_id) { where(user_id: user_id) }

  swagger_schema :PaySubscriptionInput do
    allOf do
      schema do
        key :required, [:e_wallet_id, :duration, :price]
        property :data do
          key :type, :object
          property :e_wallet_id do
            key :type, :string
            key :description, 'Unique e-wallet ID to be used to charge wallet'
          end
          property :duration do
            key :type, :integer
            key :description, 'Number of months paying for'
          end
          property :price do
            key :type, :decimal
            key :description, 'Chosen price per month'
          end
        end
      end
    end
  end

  swagger_schema :SubscriptionResponse do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :expires_on do
      key :type, :string
      key :format, :date
    end
    property :duration do
      key :type, :integer
      key :format, :int64
    end
    property :farmer_id do
      key :type, :integer
      key :format, :int64
    end
    property :created_at do
      key :type, :string
      key :format, :date
    end
    property :updated_at do
      key :type, :string
      key :format, :date
    end
  end

  swagger_schema :PaySubscriptionResponse do
    property :success do
      key :type, :boolean
    end
    property :data do
      key :type, :object
      key :'$ref', :SubscriptionResponse
    end
  end
end
