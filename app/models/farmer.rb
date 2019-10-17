class Farmer < ApplicationRecord
  extend FriendlyId
  friendly_id :first_name, use: :slugged

  include Swagger::Blocks
  include Filterable

  belongs_to :region, optional: true
  belongs_to :district, optional: true
  belongs_to :zone, optional: true
  belongs_to :community, optional: true

  has_one :card
  has_many :vaccination_schedules, dependent: :destroy
  has_many :subscriptions
  has_many :animal_tags
  has_many :farmer_payments
  has_many :payments, -> { order(created_at: :desc) }, through: :farmer_payments, dependent: :destroy
  has_many :user_farmers
  # technically a farmer has just one user
  has_many :users, through: :user_farmers, dependent: :destroy
  has_many :organization_farmers
  has_many :organizations, through: :organization_farmers, dependent: :destroy

  validates :phone_number, uniqueness: true, allow_nil: true

  before_validation(on: :create) do
    self.sex = 'M' if sex == 'Male'
    self.sex = 'F' if sex == 'Female'
  end

  validates(
  	:first_name,
  	:last_name,
  	:age,
  	:level_of_education,
    :picture,
  	presence: true
  )
  validate :sex_type

  scope :before_this_week, -> {
    where('farmers.created_at < ?',
            Date.today.beginning_of_week )}
  scope :this_month, -> {
    where('farmers.created_at >= ?',
            Date.today.beginning_of_month )}
  scope :before_this_month, -> {
      where('farmers.created_at < ?', 
              Date.today.beginning_of_month)}
  scope :before_last_month, -> {
      where( 'farmers.created_at < ?', 
              Date.today.months_ago(1).beginning_of_month)}
  scope :before_last_2_months, -> {
    where('farmers.created_at < ?', 
            Date.today.months_ago(2).beginning_of_month)}
  scope :before_last_3_months, -> {
    where('farmers.created_at < ?', 
            Date.today.months_ago(3).beginning_of_month)}
  scope :before_last_4_months, -> {
    where('farmers.created_at < ?', 
            Date.today.months_ago(4).beginning_of_month)}
  scope :last_month, -> {
    where('farmers.created_at > ? AND farmers.created_at < ?', 
            Date.today.last_month.beginning_of_month, 
            Date.today.beginning_of_month )}
  scope :last_2_months, -> {
    where('farmers.created_at > ? AND farmers.created_at < ?', 
            Date.today.months_ago(2).beginning_of_month, 
            Date.today.last_month.beginning_of_month )}
  scope :last_3_months, -> {
    where('farmers.created_at > ? AND farmers.created_at < ?', 
            Date.today.months_ago(3).beginning_of_month, 
            Date.today.months_ago(2).beginning_of_month )}
  scope :last_4_months, -> {
    where('farmers.created_at > ? AND farmers.created_at < ?', 
            Date.today.months_ago(4).beginning_of_month, 
            Date.today.months_ago(3).beginning_of_month )}
  scope :last_5_months, -> {
    where('farmers.created_at > ? AND farmers.created_at < ?', 
            Date.today.months_ago(5).beginning_of_month, 
            Date.today.months_ago(4).beginning_of_month )}
  scope :with_deleted, -> (is_deleted) { where is_deleted: is_deleted}
  scope :with_region, -> (id) { where region_id: id }
  scope :with_district, -> (id) { where district_id: id }
  scope :with_zone, -> (id) { where zone_id: id }
  scope :with_term, -> (term) { where(
    'first_name ILIKE ? '\
    'OR last_name ILIKE ? '\
    'OR phone_number LIKE ?'\
    'OR alternate_phone_number LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%"
  )}

  # this month
  scope :with_active_subscription_this_month, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at >= ?', 
      Date.today.beginning_of_day,
      Date.today.beginning_of_month
    ).distinct
  }

  # last
  scope :with_active_subscription_last_month, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at > ? AND subscriptions.created_at < ?', 
      Date.today.last_month.end_of_month,
      Date.today.last_month.beginning_of_month, 
      Date.today.beginning_of_month
    ).distinct
  }
  scope :with_active_subscription_last_2_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at > ? AND subscriptions.created_at < ?', 
      Date.today.months_ago(2).end_of_month,
      Date.today.months_ago(2).beginning_of_month, 
      Date.today.last_month.beginning_of_month
    ).distinct
  }
  scope :with_active_subscription_last_3_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at > ? AND subscriptions.created_at < ?', 
      Date.today.months_ago(3).end_of_month,
      Date.today.months_ago(3).beginning_of_month, 
      Date.today.months_ago(2).beginning_of_month
    ).distinct
  }
  scope :with_active_subscription_last_4_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at > ? AND subscriptions.created_at < ?', 
      Date.today.months_ago(4).end_of_month,
      Date.today.months_ago(4).beginning_of_month, 
      Date.today.months_ago(3).beginning_of_month
    ).distinct
  }
  scope :with_active_subscription_last_5_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at > ? AND subscriptions.created_at < ?', 
      Date.today.months_ago(5).end_of_month,
      Date.today.months_ago(5).beginning_of_month, 
      Date.today.months_ago(4).beginning_of_month
    ).distinct
  }

  # before
  scope :with_active_subscription_bf_this_month, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at < ?',
      Date.today.last_month.end_of_month,
      Date.today.beginning_of_month).distinct
  }
  scope :with_active_subscription_bf_last_month, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at < ?',
      Date.today.months_ago(2).end_of_month,
      Date.today.months_ago(1).beginning_of_month).distinct
  }
  scope :with_active_subscription_bf_last_2_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at < ?',
      Date.today.months_ago(3).end_of_month,
      Date.today.months_ago(2).beginning_of_month).distinct
  }

  scope :with_active_subscription_bf_last_3_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at < ?',
      Date.today.months_ago(4).end_of_month,
      Date.today.months_ago(3).beginning_of_month).distinct
  }
  scope :with_active_subscription_bf_last_4_months, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at < ?',
      Date.today.months_ago(5).end_of_month,
      Date.today.months_ago(4).beginning_of_month).distinct
  }
  scope :with_active_subscription_bf_this_week, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ? AND subscriptions.created_at < ?',
      Date.today.last_week.end_of_week,
      Date.today.beginning_of_week).distinct
  }
  scope :with_expired_subscription_bf_this_week, -> {
    joins(:subscriptions).where(
      'subscriptions.expires_on < ? AND subscriptions.created_at < ?',
      Date.today.last_week.end_of_week,
      Date.today.beginning_of_week).distinct
  }
  
  # postgresql stores timestamp fractional seconds
  # to query based on fractional seconds we need to be very precise
  # because timestamptz(0) rounds to the nearest second
  # we add 1 second to the time to be parsed to get a rounded result
  scope :with_created_after, -> (timestamp) {
    where("created_at::timestamptz(0) > ('#{(Time.parse(timestamp) + 1.second).iso8601(5)}')::timestamptz(0)")
    .order(created_at: :asc)
  }
  scope :with_updated_after, -> (timestamp) {
    where("updated_at::timestamptz(0) > ('#{(Time.parse(timestamp) + 1.second).iso8601(5)}')::timestamptz(0)")
    .order(updated_at: :asc)
  }
  scope :with_active_subscription, -> (today_date) {
    joins(:subscriptions).where(
      'subscriptions.expires_on > ?',
      today_date).distinct
  }
  scope :with_expired_subscription, -> (today_date) {
    joins(:subscriptions).where(
      'subscriptions.expires_on < ?',
      today_date).distinct
  }
  scope :with_user, -> (user_id) { joins(:users).where('users.id = ?', user_id) }
  scope :without_user, -> (user_id) { joins(:users).where('users.id != ?', user_id) }
  
  def sex_type
    if sex.present?
      if sex != "F" && sex != "M"
        errors.add(:sex, "must be either 'F' or 'M' ")
      end
    else
      errors.add(:sex, "can't be blank")
    end
  end

  def active_subscription
    subscriptions.where('expires_on > ?', Time.now).order('created_at DESC').firstwith_active_subscription_bf_this_week
  end

  def current_subscription
    subscriptions.order('expires_on DESC').first
  end

  swagger_schema :Farmer do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :first_name do
      key :type, :string
    end
    property :last_name do
      key :type, :string
    end
    property :phone_number do
      key :type, :string
    end
    property :alternate_phone_number do
      key :type, :string
    end
    property :district do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
    end
    property :region do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
    end
    property :zone do
      key :type, :object
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
    end
    property :community do
      key :type, :string
    end
    property :picture do
      key :type, :string
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

end
