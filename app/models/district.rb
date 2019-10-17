class District < ApplicationRecord
	include Swagger::Blocks

  belongs_to :region
  has_many :zones, dependent: :destroy
  has_many :farmers
  has_many :cases
  has_many :campaigns

  swagger_schema :District do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
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
