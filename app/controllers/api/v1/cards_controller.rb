class Api::V1::CardsController < ApplicationController
	before_action :authenticate_user!

	def create
    @card = Card.new(card_params)
    if @card.save
      render json:
		        @card,
		      serializer: Api::V1::CardSerializer,
		      adapter: :attributes
    else
      render_error_payload(:unprocessable_entity, @card.errors, status: 422) 
    end
  end
  
  private

  def card_params
    params.require(:card).permit(
      :farmer_id,
      :card_number,
	  )
  end
  
end