class Payment < ApplicationRecord
  # there are 3 endpoints that create payments
  # 1. create subscription endpoint
  # 2. update vaccination shedule endpoint
  # 3. create payments endpoint (for subscription installment payments)

  # there are also two items that can be payed for
  # 1. subscription
  # 2. vaccination

  # payments also generally belong to 2 types of user entities
  # 1. User
  # 2. Farmer

  # For any type of payment, the user making the payment on behalf of a farmer
  # receives 10% commission

  belongs_to :subscription, optional: true
  has_many :commissions

  has_many :farmer_payments
  has_many :farmers, through: :farmer_payments, dependent: :destroy

  has_many :user_payments
  has_many :users, through: :user_payments, dependent: :destroy

  after_create :create_commission

  scope :with_item, -> (item) { where(item: item) }
  scope :with_user, -> (user_id) { joins(:users).where('users.id = ?', user_id) }

  scope :this_quarter, -> {
    where(created_at: Date.today.all_quarter )}
  scope :last_quarter, -> {
    where(created_at: Date.today.prev_quarter.all_quarter )}
  scope :last_2_quarters, -> {
    where(created_at: Date.today.prev_quarter.prev_quarter.all_quarter )}
  scope :last_3_quarters, -> {
    where(created_at: Date.today.prev_quarter.prev_quarter.prev_quarter.all_quarter )}
  scope :before_this_week, -> {
    where( 'payments.created_at < ?',
            Date.today.beginning_of_week )}
  scope :this_month, -> {
    where(created_at: Date.today.all_month )}

  scope :before_this_month, -> {
      where('created_at < ?', 
              Date.today.beginning_of_month)}
  scope :before_last_month, -> {
      where( 'created_at < ?', 
              Date.today.months_ago(1).beginning_of_month)}
  scope :before_last_2_months, -> {
    where( 'created_at < ?', 
            Date.today.months_ago(2).beginning_of_month)}
  scope :before_last_3_months, -> {
    where( 'created_at < ?', 
            Date.today.months_ago(3).beginning_of_month)}
  scope :before_last_4_months, -> {
    where( 'created_at < ?', 
            Date.today.months_ago(4).beginning_of_month)}

  scope :last_month, -> {
    where(created_at: Date.today.last_month.all_month )}
  scope :last_2_months, -> {
    where(created_at: (Date.today - 2.month).all_month )}
  scope :last_3_months, -> {
    where(created_at: (Date.today - 3.month).all_month )}
  scope :last_4_months, -> {
    where(created_at: (Date.today - 4.month).all_month )}
  scope :last_5_months, -> {
    where(created_at: (Date.today - 5.month).all_month )}
  scope :last_6_months, -> {
    where(created_at: (Date.today - 6.month).all_month )}
  scope :last_7_months, -> {
    where(created_at: (Date.today - 7.month).all_month )}
  scope :last_8_months, -> {
    where(created_at: (Date.today - 8.month).all_month )}
  scope :last_9_months, -> {
    where(created_at: (Date.today - 9.month).all_month )}
  scope :last_10_months, -> {
    where(created_at: (Date.today - 10.month).all_month )}
  scope :last_11_months, -> {
    where(created_at: (Date.today - 11.month).all_month )}

  private

  def create_commission
  	subscription = Subscription.find_by_id(self.subscription_id)
    unless subscription.nil?
      self.commissions.create({ user_id: subscription.user_id, amount: 10.percent_of(self.payment_fee) })
    end
  end
end