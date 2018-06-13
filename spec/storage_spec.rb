require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/storage_service.rb'

describe('Storage Spec') do

  storage_keys = %w[directory files]
  files_keys = %w[name path url]

  not_found_resp = {
    error: 'Work not found.'
  }
  base_path = ''

  path = '/'

  before(:all) do
    AuthService.login_with_default_user
    base_path = StorageService.base_path
  end

  it 'Create a work (Auth)' do
    response = ApiRequest.create_post_request_multipart(
      base_path,
      path,
      'test_data/storage/logo.jpg',
      AuthService.auth_access_token
    )


    res = JSON.parse(response.body)

    puts res

    expect(response.code).to eq 201
  end

  it 'Get all works (size == 2) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['directory']).to eq path

    storage_keys.each do |k|
      expect(res.has_key? k).to eq true
    end

    expect(res['files'].size).to eq 2

    res['files'].each do |u|
      files_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end
  end

end