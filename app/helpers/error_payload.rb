class ErrorPayload
	attr_reader :identifier, :payload, :status

  def initialize(identifier, payload, status)
  	@identifier = identifier
    @payload = payload
    @status = status
  end

  def as_json(*)
    json = {
    	success: false,
      status: Rack::Utils.status_code(status),
      code: identifier,
      title: translated_payload[:title],
      detail: translated_payload[:detail],
    }

    if payload
      if payload.instance_of?(ActiveModel::Errors)
        json["full_messages"] = payload.full_messages # for backwards compatibility
        json["errors"] = payload
      elsif payload.is_a?(Hash)
        json["errors"] = payload
      end
    end
    json
  end

  def translated_payload
    I18n.translate("errors.#{identifier}")
  end
end