require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/storage_service.rb'

describe('Storage Spec') do

  storage_keys = %w[directory files]
  files_keys = %w[name path url]
  
  expected_response_uploaded_file = {
    name: 'logo.jpg',
    path: 'personal_page_stagelogo.jpg',
    url: 'https://s3.amazonaws.com/caballerojavier13-pages-files/personal_page_stagelogo.jpg'
  }

  no_auth_response = {
    code:401,
    message: 'auth header is empty'
  }

  base_path = ''

  path = '/'

  file_path = ''

  before(:all) do
    AuthService.login_with_default_user
    base_path = StorageService.base_path
  end

  it 'Get all files (size == 0) (Auth)' do

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

    expect(res['files'].size).to eq 0

    res['files'].each do |u|
      files_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end
  end

  it 'Get all files (No Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(no_auth_response.to_json, res.to_json)

  end

  it 'Upload a file (Auth)' do
    response = ApiRequest.create_post_request_multipart(
      base_path,
      path,
      'test_data/storage/logo.jpg',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(expected_response_uploaded_file.to_json, res.to_json)
  end

  it 'Get all files (size == 1) (Auth)' do

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

    expect(res['files'].size).to eq 1

    res['files'].each do |u|
      files_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end
  end

  it 'Upload a file (Auth)' do
    response = ApiRequest.create_post_request_multipart(
      base_path,
      path,
      'test_data/storage/logo.jpg',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(expected_response_uploaded_file.to_json, res.to_json)

    file_path = '/' + res['path']

  end

  it 'Get all files (size == 1) (Auth)' do

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

    expect(res['files'].size).to eq 1

    res['files'].each do |u|
      files_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end
  end

  it 'Upload a file (No Auth)' do
    response = ApiRequest.create_post_request_multipart(
      base_path,
      path,
      'test_data/storage/logo.jpg',
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(expected_response_uploaded_file.to_json, res.to_json)
  end

  it 'Get all files (size == 1) (Auth)' do

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

    expect(res['files'].size).to eq 1

    res['files'].each do |u|
      files_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end
  end

  it 'Delete an filed (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      file_path,
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(expected_response_uploaded_file.to_json, res.to_json)
  end

  it 'Delete an filed (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      file_path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted filed (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      file_path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'Unable to delete ' + file_path
  end

  it 'Get all files (size == 0) (Auth)' do

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

    expect(res['files'].size).to eq 0

    res['files'].each do |u|
      files_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end
  end


end