require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Researches Spec') do

  user_keys = %w[description group project time order lang id]

  data_req_new_research = {
    description: 'Desarrollo del marco teórico, representación en congresos, e implementación del sistema.',
    group: 'Laboratorio de Auditoría y Seguridad en TIC',
    project: 'Metamodelado de Auditoría y Reingeniería para Sistemas de Trazabilidad de Vinos',
    time: 'Enero 2016 - Actualidad',
    order: 2
  }

  data_req_edit_research = {
    description: 'Definición de algoritmos para la implementación de técnicas de testing formal.',
    group: 'Laboratorio de Auditoría y Seguridad en TIC',
    project: 'Calidad de Software',
    time: 'Marzo 2014 - Diciembre 2015',
    order: 1
  }

  not_found_resp = {
    error: 'Research not found.'
  }

  research_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.research_path lang
    base_path = AdminService.base_path
  end

  it 'Get all researches (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0

  end

  it 'Get all researches (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a research (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_research,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_research = data_req_new_research.clone

    research_id = data['id']

    data_res_new_research['id'] = research_id

    data_res_new_research['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_research.to_json)
    ).to eq true
  end

  it 'Get all researches (size == 1) (Auth)' do

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

  it 'Create a research (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_research,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a research (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + research_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_research = data_req_new_research.clone

    data_res_new_research['id'] = research_id

    data_res_new_research['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_research.to_json)
    ).to eq true
  end

  it 'Get a research (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + research_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + research_id,
      data_req_edit_research,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_research.clone

    data_res_edit_user_res['id'] = research_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get an edited research (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + research_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_research.clone

    data_res_edit_user_res['id'] = research_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get all researches (size == 1) (Auth)' do

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
      path + '/' + research_id,
      data_req_edit_research,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a research (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + research_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_research = data_req_edit_research.clone

    data_res_edit_research['id'] = research_id

    data_res_edit_research['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data.to_json)
    ).to eq true
  end

  it 'Delete an research (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + research_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an research (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + research_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted research (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + research_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get a deleted research (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + research_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Edit an deleted research (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + research_id,
      data_req_edit_research,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get all researches (size == 0) (Auth)' do

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