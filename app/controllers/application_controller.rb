class ApplicationController < ActionController::API
	include ActionController::RequestForgeryProtection
	include ApiErrorHandler
	protect_from_forgery with: :null_session,
	                     if: proc { |c| c.request.format == 'application/json' }
	rescue_from ActiveRecord::RecordNotFound, with: :not_found

	before_action :configure_permitted_parameters, if: :devise_controller?

	def configure_permitted_parameters
	  added_attrs = [
	  	:username,
	  	:first_name,
	  	:last_name,
	  	:phone_number,
	  	:email,
	  	:password,
	  	:password_confirmation
	  ]

	  devise_parameter_sanitizer.permit(
	    :sign_up,
	    keys: added_attrs
	  )
	  devise_parameter_sanitizer.permit(
	    :account_update,
	    keys: added_attrs
	  )
	end

	protected

	def not_found(e)
	  render_error_payload(:record_not_found, nil, status: :not_found)
	end
	  
  def render_error_payload(identifier, payload, status: :bad_request)
    render json: ErrorPayload.new(identifier, payload, status), status: status
  end
end
