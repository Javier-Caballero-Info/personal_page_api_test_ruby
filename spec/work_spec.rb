require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Works Spec') do

  user_keys = %w[company description position order time id]

  data_req_new_work = {
    company: 'Globant',
    description: 'Ingeniero en calidad de juegos (GQE game quality engineer), para Disney en proyectos de video juegos para iOS y Android. Encargado de automatización de pruebas.',
    position: 'Tester Automation Engineer',
    order: 4,
    time: 'Septiembre 2017 - Actualidad'
  }

  data_req_edit_work = {
    company: 'Globant S.A.',
    description: 'Ingeniero en calidad de juegos (GQE game quality engineer), para Disney en proyectos de video juegos para iOS y Android. Encargado de automatización de pruebas.',
    position: 'Test Automation Engineer',
    order: 4,
    time: 'Agosto 2017 - Actualidad'
  }

  not_found_resp = {
    error: 'Work not found.'
  }

  work_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.work_path lang
    base_path = AdminService.base_path
  end

  it 'Get all works (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0
  end

  it 'Get all works (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a work (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_work,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_work = data_req_new_work.clone

    work_id = data['id']

    data_res_new_work['id'] = work_id

    data_res_new_work['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_work.to_json)
    ).to eq true
  end

  it 'Get all works (size == 1) (Auth)' do

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

  it 'Create a work (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_work,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a work (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + work_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_work = data_req_new_work.clone

    data_res_new_work['id'] = work_id

    data_res_new_work['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_work.to_json)
    ).to eq true
  end

  it 'Get a work (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + work_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + work_id,
      data_req_edit_work,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_work.clone

    data_res_edit_user_res['id'] = work_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get an edited work (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + work_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_work.clone

    data_res_edit_user_res['id'] = work_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get all works (size == 1) (Auth)' do

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
      path + '/' + work_id,
      data_req_edit_work,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a work (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + work_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_work = data_req_edit_work.clone

    data_res_edit_work['id'] = work_id

    data_res_edit_work['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data.to_json)
    ).to eq true
  end

  it 'Delete an work (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + work_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an work (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + work_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted work (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + work_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get a deleted work (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + work_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Edit an deleted work (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + work_id,
      data_req_edit_work,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get all works (size == 0) (Auth)' do

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