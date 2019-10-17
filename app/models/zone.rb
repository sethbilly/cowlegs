class Zone < ApplicationRecord
	include Swagger::Blocks
	
	belongs_to :district
	has_many :vaccination_schedules
  has_many :farmers
  has_many :communities
  has_many :users
	has_many :cases
	has_many :campaign_zones
  has_many :campaigns, through: :campaign_zones, dependent: :destroy

	validates :name, presence: true, uniqueness: true

	swagger_schema :Zone do
	  property :id do
	    key :type, :integer
	    key :format, :int64
	  end
	  property :name do
	    key :type, :string
	  end
	  property :code do
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
end
