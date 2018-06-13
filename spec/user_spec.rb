require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'

describe('Users Spec') do

  user_keys = %w[email first_name last_name username]

  data_req_new_user = {
    email: 'new_user@gmail.com',
    first_name: 'New',
    last_name: 'User',
    password: 'new_user',
    username: 'new_user'
  }

  data_req_edit_user = {
    email: 'edited_user@gmail.com',
    first_name: 'Edited',
    last_name: 'User',
    username: 'edited_user'
  }

  not_found_resp = {
    code: 404,
    message: 'User not found',
    type: 'NOT_FOUND'
  }

  my_user_info = {
    email: 'caballerojavier13@gmail.com',
    first_name: 'Javier',
    last_name: 'Caballero',
    username: 'caballerojavier13'
  }

  user_id = ''

  before(:all) do
    AuthService.login_with_default_user
  end

  it 'Get all users (size == 1) (Auth)' do

    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.size).to be 1

    res.each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Get all users (No Auth)' do
    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users',
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

  it 'Create an user (Auth)' do
    response = ApiRequest.create_post_request(
      AuthService.base_path,
      '/v1/users',
      data_req_new_user,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('id')).to eq true

    data_res_new_user = data_req_new_user

    user_id = res['id']

    data_res_new_user['id'] = user_id

    expect(
      JsonUtilities.compare_json(res.to_json, data_res_new_user.to_json)
    ).to eq true
  end

  it 'Get all users (size == 2) (Auth)' do

    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.size).to be 2

    res.each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Create an user (No Auth)' do
    response = ApiRequest.create_post_request(
      AuthService.base_path,
      '/v1/users',
      data_req_new_user,
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'

  end

  it 'Get an user (Auth)' do
    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('id')).to eq true

    data_res_new_user = data_req_new_user.clone

    user_id = res['id']

    data_res_new_user['id'] = user_id

    expect(
      JsonUtilities.compare_json(res.to_json, data_res_new_user.to_json)
    ).to eq true
  end

  it 'Get an user (No Auth)' do
    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      data_req_edit_user,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    data_res_edit_user_res = data_req_edit_user.clone

    data_res_edit_user_res['id'] = user_id

    expect(
      JsonUtilities.compare_json(res.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get all users (size == 2) (Auth)' do

    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.size).to be 2

    res.each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Edit an user (No Auth)' do
    response = ApiRequest.create_put_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      data_req_edit_user,
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'

  end

  it 'Delete an user (No Auth)' do
    response = ApiRequest.create_delete_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

  it 'Delete an user (Auth)' do
    response = ApiRequest.create_delete_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted user (Auth)' do
    response = ApiRequest.create_delete_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get a deleted user (Auth)' do
    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Edit an deleted user (Auth)' do
    response = ApiRequest.create_put_request(
      AuthService.base_path,
      '/v1/users/' + user_id,
      data_req_edit_user,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get all users (size == 1) (Auth)' do

    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/users',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.size).to be 1

    res.each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Get my user (Auth)' do
    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/me',
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('id')).to eq true

    my_user_info['id'] = res['id']

    expect(
      JsonUtilities.compare_json(res.to_json, my_user_info.to_json)
    ).to eq true
  end

  it 'Get my user (No Auth)' do
    response = ApiRequest.create_get_request(
      AuthService.base_path,
      '/v1/me',
      nil
    )

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

end