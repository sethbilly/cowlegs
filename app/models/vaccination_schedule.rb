class VaccinationSchedule < ApplicationRecord

	include Swagger::Blocks

  belongs_to :zone, optional: true
  belongs_to :type_of_campaign
  belongs_to :farmer
  belongs_to :campaign, optional: true

  validates :herd_size, :activity, :animal_group, presence: true

  enum status: [:pending, :failed, :rescheduled, :completed]
  
  after_commit :set_campaign_status, on: :update

  scope :with_not_completed, -> { where.not(status: 3).distinct }
  scope :with_pending, -> { where(status: 0).distinct }
  scope :with_completed, -> { where(status: 3).distinct }
  scope :with_zones, -> (zone_ids) { where zone_id: zone_ids }
  scope :with_campaign_id, -> (campaign_id) { where campaign_id: campaign_id }
  scope :with_type_of_campaign, -> (type_of_campaign_id) { where type_of_campaign_id: type_of_campaign_id }
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

  swagger_schema :VaccinationSchedule do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :activity do
      key :type, :string
    end
    property :type_of_vaccination do
      key :type, :string
    end
    property :herd_size do
      key :type, :integer
      key :format, :int64
    end
    property :zone do
      key :type, :string
    end
    property :animal_group do
      key :type, :string
    end
    property :notes do
      key :type, :string
    end
    property :farmer do
      key :type, :object
      key :'$ref', :Farmer
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

def get_farmer
  Farmer.find_by_id(self.farmer_id)
end


  def set_campaign_status
    # lets not trigger 404
    campaign = Campaign.find_by_id(campaign_id)
    unless campaign.nil?
      completed_schedules = campaign.vaccination_schedules.where({ status: 'completed' })
      if completed_schedules.count == campaign.vaccination_schedules.count
        campaign.update_attribute(:status, 'completed')
      end
    end
  end

end
