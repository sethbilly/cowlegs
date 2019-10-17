class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Shepherd'
      key :description, 'Shepherd API'
      key :termsOfService, 'http://www.cowtribe.com/'
      contact do
        key :name, 'Cowtribe'
      end
      license do
        key :name, 'MIT'
      end
    end
    tag do
      key :name, 'Cowtribe'
      key :description, 'Shepherd API'
    end
    
    key :host, ENV['ROOT_URL']
    key :basePath, '/api'
    key :consumes, ['application/json', 'application/x-www-form-urlencoded', 'multipart/form-data']
    key :produces, ['application/json']
    
    security_definition :access_token do
      key :type, :apiKey
      key :name, :Authorization
      key :in, :header
    end
  end

  # A list of all classes that have swagger_* declarations.
    SWAGGERED_CLASSES = [
      Api::V1::SessionsController,
      Api::V1::RegistrationsController,
      Api::V1::UsersController,
      User,
      Subscription,
      Api::V1::SubscriptionsController,
      Api::V1::FarmersController,
      Farmer,
      Api::V1::DistrictsController,
      District,
      Api::V1::RegionsController,
      Region,
      Api::V1::ZonesController,
      Zone,
      VaccinationSchedule,
      Api::V1::CampaignsController,
      Campaign,
      Api::V1::CampaignSubscriptionsController,
      CampaignSubscription,
      Api::V1::CommunitiesController,
      Community,
      ErrorModel,
      self,
    ].freeze

  def index
    # serve generated json
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
