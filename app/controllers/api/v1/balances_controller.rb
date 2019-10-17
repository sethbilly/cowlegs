class Api::V1::BalancesController < ApplicationController
  include Swagger::Blocks

  swagger_path 'api/v1/wallet/get_farmer_balance/{phone_number}' do
    operation :get do
      key :description, 'Show wallet balance for farmer'
      key :operationId, 'ShowFarmerAccountBalance'

      key :tags, [
          'Wallet'
      ]
      parameter do
        key :name, :phone_number
        key :in, :query
        key :description, 'Supply phone number of subscriber'
        key :required, true
        key :type, :string
      end
      response 200 do
        key :description, 'Returns a JSON object of wallet balance'
        schema do
          key :'$ref', :UserDataResponse
        end
      end
    end
  end

  def farmer_account_balance
    @balance = FarmerPayment.where(farmer_id: @farmer.id).pluck('SUM(credit)' - 'SUM(debit)')
  end

  def agent_account_balance
    @balance = UserPayment.where(user_id: @agent.id).pluck('SUM(credit)' - 'SUM(debit)')
  end

  def set_farmer
    @farmer = Farmer.where(phone_number: params([:phone_number]))
  end

  def set_agent
    @agent = User.where(phone_number: params([:phone_number]))
  end
end
