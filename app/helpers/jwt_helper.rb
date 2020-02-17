# frozen_string_literal: true

module JwtHelper
  def self.generate_jwt_token(duration, payload)
    issued_at = not_before = Time.zone.now.to_i
    expire = not_before + duration

    jwt = {
      iss: 'deali.net',
      jti: self.userid,
      iat: issued_at,
      nbf: not_before,
      exp: expire,
      data: payload
    }
    JsonWebToken.encode(jwt) 
  end

end

