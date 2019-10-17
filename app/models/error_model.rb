class ErrorModel
  include Swagger::Blocks

  swagger_schema :ErrorModel do
    key :required, [:success, :status, :data, :errors]
    property :success do
      key :type, :boolean
    end
    property :status do
      key :type, :string
    end
    property :data do
      key :type, :object
    end
    property :errors do
      key :type, :array
      items do
        key :type, :string
      end
    end
  end
end
