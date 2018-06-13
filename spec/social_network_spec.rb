require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Social_networks Spec') do

  user_keys = %w[img link name lang order id]

  data_req_new_social_network = {
    img: 'https://s3.amazonaws.com/caballerojavier13-pages-files/personal_page/Redes_Sociales/facebook.png',
    link: 'https://www.facebook.com/caballerojavier13',
    name: 'Facebook',
    order: 1
  }

  data_req_edit_social_network = {
    img: 'https://s3.amazonaws.com/caballerojavier13-pages-files/personal_page/Redes_Sociales/instagram.png',
    link: 'https://instagram.com/caballerojavier13/',
    name: 'Instagram',
    order: 2
  }

  not_found_resp = {
    error: 'Social Network not found.'
  }

  social_network_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.social_network_path lang
    base_path = AdminService.base_path
  end

  it 'Get all social_networks (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0

  end

  it 'Get all social_networks (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a social_network (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_social_network,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_social_network = data_req_new_social_network.clone

    social_network_id = data['id']

    data_res_new_social_network['id'] = social_network_id

    data_res_new_social_network['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_new_social_network.to_json, data.to_json)
  end

  it 'Get all social_networks (size == 1) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 1

    res['data'].each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Create a social_network (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_social_network,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a social_network (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + social_network_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_social_network = data_req_new_social_network.clone

    data_res_new_social_network['id'] = social_network_id

    data_res_new_social_network['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_new_social_network.to_json, data.to_json)
  end

  it 'Get a social_network (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + social_network_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + social_network_id,
      data_req_edit_social_network,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_social_network = data_req_edit_social_network.clone

    data_res_edit_social_network['id'] = social_network_id

    data_res_edit_social_network['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_social_network.to_json, data.to_json)
  end

  it 'Get an edited social_network (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + social_network_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_social_network = data_req_edit_social_network.clone

    data_res_edit_social_network['id'] = social_network_id

    data_res_edit_social_network['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_social_network.to_json, data.to_json)
  end

  it 'Get all social_networks (size == 1) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 1

    res['data'].each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Edit an user (No Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + social_network_id,
      data_req_edit_social_network,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a social_network (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + social_network_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_social_network = data_req_edit_social_network.clone

    data_res_edit_social_network['id'] = social_network_id

    data_res_edit_social_network['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_social_network.to_json, data.to_json)
  end

  it 'Delete an social_network (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + social_network_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an social_network (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + social_network_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted social_network (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + social_network_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Get a deleted social_network (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + social_network_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Edit an deleted social_network (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + social_network_id,
      data_req_edit_social_network,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Get all social_networks (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0

  end

end