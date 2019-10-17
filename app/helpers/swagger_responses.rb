module SwaggerResponses
  module AuthenticationError
    def self.extended(base)
      base.response 401 do
        key :description, 'not authorized'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  module ModelCreateError
    def self.extended(base)
      base.response 422 do
        key :description, 'Unprocessable entity'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
end