require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Educations Spec') do

  user_keys = %w[icon img info lang name, order, id]

  data_req_new_education = {
    career: 'Ing en Sist de Información',
    detail: 'Promedio 7.14',
    institute: 'Universidad Tecnológica Nacional',
    time: '2014 - Actualidad',
    order: 1
  }

  data_req_edit_education = {
    career: 'Ingeniería en Sistemas de Información',
    detail: 'Promedio 8.22',
    institute: 'Universidad Tecnológica Nacional-Facultad Regional Mendoza',
    time: '2010 - Actualidad',
    order: 3
  }

  not_found_resp = {
    error: 'Education not found.'
  }

  education_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.education_path lang
    base_path = AdminService.base_path
  end

  it 'Get all educations (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0

    res['data'].each do |u|
      user_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Get all educations (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a education (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_education,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_education = data_req_new_education.clone

    education_id = data['id']

    data_res_new_education['id'] = education_id

    data_res_new_education['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_education.to_json)
    ).to eq true
  end

  it 'Create a education (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_education,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a education (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + education_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_education = data_req_new_education.clone

    data_res_new_education['id'] = education_id

    data_res_new_education['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_education.to_json)
    ).to eq true
  end

  it 'Get a education (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + education_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + education_id,
      data_req_edit_education,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_education.clone

    data_res_edit_user_res['id'] = education_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get an edited education (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + education_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_education.clone

    data_res_edit_user_res['id'] = education_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Edit an user (No Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + education_id,
      data_req_edit_education,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a education (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + education_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_education = data_req_edit_education.clone

    data_res_edit_education['id'] = education_id

    data_res_edit_education['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data.to_json)
    ).to eq true
  end

  it 'Delete an education (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + education_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an education (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + education_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted education (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + education_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(res.to_json, not_found_resp.to_json)
    ).to eq true
  end

  it 'Get a deleted education (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + education_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(res.to_json, not_found_resp.to_json)
    ).to eq true
  end

  it 'Edit an deleted education (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + education_id,
      data_req_edit_education,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(res.to_json, not_found_resp.to_json)
    ).to eq true
  end

end