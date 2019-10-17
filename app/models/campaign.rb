class Campaign < ApplicationRecord

  extend FriendlyId
  friendly_id :code, use: :slugged
  
  include Swagger::Blocks
  include Filterable

  belongs_to :type_of_campaign
  belongs_to :region
  belongs_to :district
  has_many :vaccination_schedules, dependent: :destroy
  has_many :provider_campaigns
  has_many :users, through: :provider_campaigns, dependent: :destroy
  has_many :campaign_zones
  has_many :zones, through: :campaign_zones, dependent: :destroy
  has_many :campaign_messages
  has_many :messages, through: :campaign_messages, dependent: :destroy

  enum status: [:scheduled, :live, :completed]

  scope :with_status, -> (status) { where status: status }
  scope :with_region, -> (id) { where region_id: id }
  scope :with_district, -> (id) { where district_id: id }
  scope :with_zone, -> (zone_id) { joins(:campaign_zones).where('campaign_zones.zone_id = ?', zone_id) }

  before_create :add_code

  swagger_schema :Campaign do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :code do
      key :type, :string
    end
    property :start_date do
      key :type, :string
      key :format, :date
    end
    property :end_date do
      key :type, :string
      key :format, :date
    end
    property :zone do
      key :type, :string
    end
    property :type_of_campaign_id do
      key :type, :integer
      key :format, :int64
    end
    property :zone_id do
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

  swagger_schema :CampaignInput do
    allOf do
      schema do
        property :campaign do
          key :type, :object
          property :start_date do
            key :type, :string
            key :format, :date
          end
          property :end_date do
            key :type, :string
            key :format, :date
          end
          property :zone_id do
            key :type, :integer
            key :format, :int64
          end
          property :type_of_campaign_id do
            key :type, :integer
            key :format, :int64
          end
        end
      end
    end
  end

  swagger_schema :AddScheduleToCampaignInput do
    allOf do
      schema do
        property :data do
          key :type, :object
          property :campaign_id do
            key :type, :integer
            key :format, :int64
          end
          property :vaccination_schedule_id do
            key :type, :integer
            key :format, :int64
          end
        end
      end
    end
  end

  swagger_schema :AddProviderToCampaignInput do
    allOf do
      schema do
        property :data do
          key :type, :object
          property :campaign_id do
            key :type, :integer
            key :format, :int64
          end
          property :provider_id do
            key :type, :integer
            key :format, :int64
          end
        end
      end
    end
  end

  swagger_schema :CampaignDataResponse do
    property :success do
      key :type, :boolean
    end
    property :data do
      key :type, :object
      key :'$ref', :Campaign
    end
  end

  private

  def add_code
    type_of_campaign = TypeOfCampaign.find(type_of_campaign_id)
    code = ''
    self.zone_ids.each do |zone_id|
      # lets not trigger 404
      zone = Zone.find_by_id(zone_id)
      code += zone.code.to_s
    end
    self.code = loop do
      gen_code = code + type_of_campaign.code.to_s + SecureRandom.hex(2).upcase
      break gen_code unless self.class.exists?(code: gen_code)
    end
  end

end
