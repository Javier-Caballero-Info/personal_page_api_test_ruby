require 'net/http'
require 'uri'
require 'json'
require 'rest-client'

@auth_access_token = ''
@auth_refresh_token = ''

def base_path
  ENV['BASE_PATH_AUTH']
end

def right_credentials
  {
    username: ENV['RIGHT_USERNAME'],
    password: ENV['RIGHT_PASSWORD']
  }
end

def wrong_credentials
  {
    username: ENV['WRONG_USERNAME'],
    password: ENV['WRONG_PASSWORD']
  }
end

def create_get_request(path, auth_token)
  header = {
    content_type: :json,
    accept: :json
  }

  header['Authorization'] = 'Bearer ' + auth_token unless auth_token.nil?

  begin
    RestClient.get base_path + path, header
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

def create_post_request(path, data, auth_token)
  header = {
    content_type: :json,
    accept: :json
  }

  header['Authorization'] = 'Bearer ' + auth_token unless auth_token.nil?

  begin
    RestClient.post base_path + path, data.to_json, header
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

def create_put_request(path, data, auth_token)
  header = {
    content_type: :json,
    accept: :json
  }

  header['Authorization'] = 'Bearer ' + auth_token unless auth_token.nil?

  begin
    RestClient.put base_path + path, data.to_json, header
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

def create_delete_request(path, auth_token)
  header = {
    content_type: :json,
    accept: :json
  }

  header['Authorization'] = 'Bearer ' + auth_token unless auth_token.nil?

  begin
    RestClient.delete base_path + path, header
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

def login(username, password)
  credentials = {
    username: username,
    password: password
  }

  response = create_post_request('/v1/session', credentials, nil)

  res = JSON.parse(response.body)

  if response.code == 201
    @auth_access_token = res['access_token'].to_s
    @auth_refresh_token = res['refresh_token'].to_s
  end

  response
end

def refresh_token

  response = create_put_request('/v1/session', {}, @auth_refresh_token)

  res = JSON.parse(response.body)

  @auth_access_token = res['access_token'].to_s

end

def login_with_default_user
  login(right_credentials[:username], right_credentials[:password])
end
