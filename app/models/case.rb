class Case < ApplicationRecord
  belongs_to :species
  belongs_to :user
  belongs_to :district, optional: true
  belongs_to :zone, optional: true
  
  validates :location, :pictures, presence: true
  validates(
    :community,
    :age,
    :sex,
    :system,
    :number_dead,
    :number_at_risk,
    :number_examined,
    :measures_adopted,
    presence: true, if: :is_active?
  )

  before_save :set_location
  
  has_many :case_symptoms
  has_many :symptoms, through: :case_symptoms, dependent: :destroy

  enum type_of_case: [:active, :passive]

  enum status: [:draft, :final]

  scope :with_user, -> (user_id) { where(user_id: user_id) }
  scope :before_this_week, -> {
    where('created_at < ?',
            Date.today.beginning_of_week )}
  scope :this_month, -> {
    where('created_at >= ?',
            Date.today.beginning_of_month )}
  scope :last_month, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.last_month.beginning_of_month, 
            Date.today.beginning_of_month )}
  scope :last_2_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(2).beginning_of_month, 
            Date.today.last_month.beginning_of_month )}
  scope :last_3_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(3).beginning_of_month, 
            Date.today.months_ago(2).beginning_of_month )}
  scope :last_4_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(4).beginning_of_month, 
            Date.today.months_ago(3).beginning_of_month )}
  scope :last_5_months, -> {
    where( 'created_at > ? AND created_at < ?', 
            Date.today.months_ago(5).beginning_of_month, 
            Date.today.months_ago(4).beginning_of_month )}
  scope :from_this_month, -> {
      where( 'created_at >= ?',
              Date.today.beginning_of_month )}
  scope :from_last_month, -> {
      where( 'created_at >= ?', 
              Date.today.last_month.beginning_of_month )}
  scope :from_last_week, -> {
      where( 'created_at >= ?', 
              Date.today.last_week.beginning_of_week )}
  scope :from_this_week, -> {
      where( 'created_at >= ?',
              Date.today.beginning_of_week )}

  def is_active?
  	self.type_of_case == 'active'
  end

  private

  def set_location
    if self.location && self.location.class == String
      self.location = eval(location)
    end
  end
end
