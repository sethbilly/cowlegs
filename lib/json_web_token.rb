class JsonWebToken
  def self.encode(payload, exp = 24.hours.from.now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    body = JWT.dedcode(token, Rails.application.secrets.secret_key_base)
    HashWithIndifferentAccess.new body
  rescue StandardError => error
    nil
  end
end