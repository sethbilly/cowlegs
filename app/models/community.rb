class Community < ApplicationRecord
  belongs_to :zone
  has_many :farmers

  validates :address, presence: true, uniqueness: true
  validates :lat, :lng, presence: true

  include Swagger::Blocks

  swagger_schema :Community do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :address do
      key :type, :string
    end
    property :lat do
      key :type, :string
    end
    property :lng do
      key :type, :string
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
