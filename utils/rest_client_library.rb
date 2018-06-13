require 'net/http'
require 'uri'
require 'json'
require 'rest-client'

module ApiRequest

  def self.create_get_request(base_path, path, auth_token)
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

  def self.create_post_request(base_path, path, data, auth_token)
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

  def self.create_post_request_multipart(base_path, path, file_path, auth_token)
    header = {
      content_type: 'multipart/form-data',
      accept: :json,
    }

    header['authorization'] = 'Bearer ' + auth_token unless auth_token.nil?

    begin
      RestClient.post base_path + path, {:upload => File.new(file_path, 'rb')}, header
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end

  def self.create_put_request(base_path, path, data, auth_token)
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

  def self.create_delete_request(base_path, path, auth_token)
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

end