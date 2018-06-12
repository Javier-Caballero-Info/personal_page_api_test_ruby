require_relative '../utils/rest_client_library.rb'

module AuthService

  def self.auth_access_token
    @auth_access_token
  end

  def self.auth_access_token=(auth_access_token)
    @auth_access_token = auth_access_token
  end

  def self.auth_refresh_token
    @auth_refresh_token
  end

  def self.auth_refresh_token=(auth_refresh_token)
    @auth_refresh_token = auth_refresh_token
  end

  def self.base_path
    ENV['BASE_PATH_AUTH']
  end

  def self.right_credentials
    {
      username: ENV['RIGHT_USERNAME'],
      password: ENV['RIGHT_PASSWORD']
    }
  end

  def self.wrong_credentials
    {
      username: ENV['WRONG_USERNAME'],
      password: ENV['WRONG_PASSWORD']
    }
  end

  def self.login(username, password)
    credentials = {
      username: username,
      password: password
    }

    response = ApiRequest.create_post_request(base_path, '/v1/session', credentials, nil)

    res = JSON.parse(response.body)

    if response.code == 201
      @auth_access_token = res['access_token'].to_s
      @auth_refresh_token = res['refresh_token'].to_s
    end

    response
  end

  def self.refresh_token

    response = ApiRequest.create_put_request(
      base_path,
      '/v1/session',
      {},
      @auth_refresh_token
    )

    res = JSON.parse(response.body)

    @auth_access_token = res['access_token'].to_s

  end

  def self.login_with_default_user
    login(right_credentials[:username], right_credentials[:password])
  end

end