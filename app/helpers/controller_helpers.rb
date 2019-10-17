module ControllerHelpers
  def not_found(e)
    api_error(status: 404, errors: e.message)
  end
end
