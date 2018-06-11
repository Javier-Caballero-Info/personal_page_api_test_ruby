require 'jwt'

def validate_awt_token(token)
  hmac_secret = ENV['JWT_SECRET_KEY']

  !(JWT.decode token, hmac_secret, true, algorithm: ENV['JWT_SIGN_ALGORITHM']).nil?
end