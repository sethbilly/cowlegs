class Region < ApplicationRecord
	include Swagger::Blocks

	has_many :districts, dependent: :destroy
	has_many :farmers
	has_many :campaigns

	swagger_schema :Region do
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
