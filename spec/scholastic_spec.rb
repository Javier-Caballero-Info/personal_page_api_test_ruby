require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Scholastic Spec') do

  user_keys = %w[description institute subject time lang order id]

  data_req_new_scholastic = {
    description: 'Ayudante de Cátedra de 2da Ad-Honorem',
    institute: 'Universidad Tecnológica Nacional-Facultad Regional Mendoza',
    subject: 'Ingeniería en Sistemas de Información-Sistemas de Representación',
    time: 'Marzo 2014 - Actualidad',
    order: 2
  }

  data_req_edit_scholastic = {
    description: 'Ayudante de Cátedra de 2da Ad-Honorem',
    institute: 'Universidad Tecnológica Nacional-Facultad Regional Mendoza',
    subject: 'Ingeniería en Sistemas de Información-Paradigmas de Programación',
    time: 'Julio 2012 - Julio 2013',
    order: 1
  }

  not_found_resp = {
    error: 'Scholastic not found.'
  }

  scholastic_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.scholastic_path lang
    base_path = AdminService.base_path
  end

  it 'Get all scholastic (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0

  end

  it 'Get all scholastic (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a scholastic (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_scholastic,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_scholastic = data_req_new_scholastic.clone

    scholastic_id = data['id']

    data_res_new_scholastic['id'] = scholastic_id

    data_res_new_scholastic['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_new_scholastic.to_json, data.to_json)
  end

  it 'Get all scholastic (size == 1) (Auth)' do

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

  it 'Create a scholastic (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_scholastic,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a scholastic (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + scholastic_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_scholastic = data_req_new_scholastic.clone

    data_res_new_scholastic['id'] = scholastic_id

    data_res_new_scholastic['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_new_scholastic.to_json, data.to_json)
  end

  it 'Get a scholastic (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + scholastic_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + scholastic_id,
      data_req_edit_scholastic,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_scholastic = data_req_edit_scholastic.clone

    data_res_edit_scholastic['id'] = scholastic_id

    data_res_edit_scholastic['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_scholastic.to_json, data.to_json)
  end

  it 'Get an edited scholastic (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + scholastic_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_scholastic = data_req_edit_scholastic.clone

    data_res_edit_scholastic['id'] = scholastic_id

    data_res_edit_scholastic['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_scholastic.to_json, data.to_json)
  end

  it 'Edit an user (No Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + scholastic_id,
      data_req_edit_scholastic,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a scholastic (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + scholastic_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_scholastic = data_req_edit_scholastic.clone

    data_res_edit_scholastic['id'] = scholastic_id

    data_res_edit_scholastic['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_scholastic.to_json, data.to_json)
  end

  it 'Get all scholastic (size == 1) (Auth)' do

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

  it 'Delete an scholastic (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + scholastic_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an scholastic (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + scholastic_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted scholastic (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + scholastic_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Get a deleted scholastic (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + scholastic_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Edit an deleted scholastic (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + scholastic_id,
      data_req_edit_scholastic,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Get all scholastic (size == 0) (Auth)' do

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