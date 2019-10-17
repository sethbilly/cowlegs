module ApiErrorHandler
  def api_error(status: 500, errors: [], data: [])
    unless Rails.env.production?
      puts errors.full_messages if errors.respond_to? :full_messages
    end
    if errors.empty?
      head status: status
      return
    end
    render json: format_errors(errors, data).to_json, status: status
  end

  def format_errors(errors, data)
    return errors if errors.is_a? String
    errors_hash = {}
    errors_hash[:success] = false
    errors_hash[:status] = 'error'
    errors_hash[:data] = data
    errors_hash[:errors] = errors
    errors_hash[:full_messages] = errors.full_messages if errors.respond_to? :full_messages
    errors_hash
  end
end
