require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'

describe('Contacts Spec') do

  user_keys = %w[icon img info lang name, order, id]

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

  contact_id = ''

  lang = 'es'

  before(:all) do
    login_with_default_user
  end

  it 'Get all contacts (Auth)' do

    login_with_default_user

    response = create_get_request('/' + lang + '/contacts', @auth_access_token)

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to >= 0

    res['data'].each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Get all contacts (No Auth)' do
    response = create_get_request('/' + lang + '/contacts', nil)

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

=begin

  it 'Create an user (Auth)' do
    response = create_post_request('/v1/users', data_req_new_user, @auth_access_token)

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('id')).to eq true

    data_res_new_user = data_req_new_user

    user_id = res['id']

    data_res_new_user['id'] = user_id

    expect(JsonUtilities.compare_json(
             res.to_json, data_res_new_user.to_json
    )).to eq true
  end

  it 'Create an user (No Auth)' do
    response = create_post_request('/v1/users', data_req_new_user, nil)

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'

  end

  it 'Get an user (Auth)' do
    response = create_get_request('/v1/users/' + user_id, @auth_access_token)

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('id')).to eq true

    data_res_new_user = data_req_new_user.clone

    user_id = res['id']

    data_res_new_user['id'] = user_id

    expect(JsonUtilities.compare_json(
        res.to_json, data_res_new_user.to_json
    )).to eq true
  end

  it 'Get an user (No Auth)' do
    response = create_get_request('/v1/users/' + user_id, nil)

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

  it 'Edit an user (Auth)' do
    response = create_put_request('/v1/users/' + user_id, data_req_edit_user, @auth_access_token)

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    data_res_edit_user_res = data_req_edit_user.clone

    data_res_edit_user_res['id'] = user_id

    expect(JsonUtilities.compare_json(
        res.to_json, data_res_edit_user_res.to_json
    )).to eq true
  end

  it 'Edit an user (No Auth)' do
    response = create_put_request('/v1/users/' + user_id, data_req_edit_user, nil)

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'

  end

  it 'Delete an user (No Auth)' do
    response = create_delete_request('/v1/users/' + user_id, nil)

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

  it 'Delete an user (Auth)' do
    response = create_delete_request('/v1/users/' + user_id, @auth_access_token)

    expect(response.code).to eq 204
  end

  it 'Delete a deleted user (Auth)' do
    response = create_delete_request('/v1/users/' + user_id, @auth_access_token)

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(JsonUtilities.compare_json(
        res.to_json, not_found_resp.to_json
    )).to eq true
  end

  it 'Get a deleted user (Auth)' do
    response = create_get_request('/v1/users/' + user_id, @auth_access_token)

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(JsonUtilities.compare_json(
        res.to_json, not_found_resp.to_json
    )).to eq true
  end

  it 'Edit an deleted user (Auth)' do
    response = create_put_request('/v1/users/' + user_id, data_req_edit_user, @auth_access_token)

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(JsonUtilities.compare_json(
        res.to_json, not_found_resp.to_json
    )).to eq true
  end

  it 'Get my user (Auth)' do
    response = create_get_request('/v1/me', @auth_access_token)

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('id')).to eq true

    my_user_info['id'] = res['id']

    expect(JsonUtilities.compare_json(
             res.to_json, my_user_info.to_json
    )).to eq true
  end

  it 'Get my user (No Auth)' do
    response = create_get_request('/v1/me', nil)

    expect(response.code).to eq 401

    res = JSON.parse(response.body)

    expect(res['msg']).to eq 'Missing Authorization Header'
  end

=end

end