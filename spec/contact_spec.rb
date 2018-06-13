require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Contacts Spec') do

  user_keys = %w[icon img info lang name order id]

  data_req_new_contact = {
    icon: 'icon-whatsapp',
    img: 'https://s3.amazonaws.com/caballerojavier13-pages-files/personal_page/Mensajeria/whatsapp.png',
    info: '+54-263-4200-463',
    name: 'Whatsapp',
    order: 1
  }

  data_req_edit_contact = {
    icon: 'icon-telegram',
    img: 'https://s3.amazonaws.com/caballerojavier13-pages-files/personal_page/Mensajeria/telegram.png',
    info: 'caballerojavier13',
    name: 'Telegram',
    order: 2
  }

  not_found_resp = {
    error: 'Contact not found.'
  }

  contact_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.contact_path lang
    base_path = AdminService.base_path
  end

  it 'Get all contacts (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0

  end

  it 'Get all contacts (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a contact (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_contact,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_contact = data_req_new_contact.clone

    contact_id = data['id']

    data_res_new_contact['id'] = contact_id

    data_res_new_contact['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_contact.to_json)
    ).to eq true
  end

  it 'Get all contacts (size == 1) (Auth)' do

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

  it 'Create a contact (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_contact,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a contact (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + contact_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_contact = data_req_new_contact.clone

    data_res_new_contact['id'] = contact_id

    data_res_new_contact['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data_res_new_contact.to_json)
    ).to eq true
  end

  it 'Get a contact (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + contact_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an user (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + contact_id,
      data_req_edit_contact,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_contact.clone

    data_res_edit_user_res['id'] = contact_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Get an edited contact (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + contact_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_user_res = data_req_edit_contact.clone

    data_res_edit_user_res['id'] = contact_id

    data_res_edit_user_res['lang'] = lang.to_s.upcase

    expect(
      JsonUtilities.compare_json(data.to_json, data_res_edit_user_res.to_json)
    ).to eq true
  end

  it 'Edit an user (No Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + contact_id,
      data_req_edit_contact,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a contact (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + contact_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_contact = data_req_edit_contact.clone

    data_res_edit_contact['id'] = contact_id

    data_res_edit_contact['lang'] = lang.to_s.upcase

    expect(JsonUtilities.compare_json(
      data.to_json, data.to_json)
    ).to eq true
  end

  it 'Get all contacts (size == 1) (Auth)' do

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

  it 'Delete an contact (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + contact_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an contact (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + contact_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted contact (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + contact_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get a deleted contact (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + contact_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Edit an deleted contact (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + contact_id,
      data_req_edit_contact,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    expect(
      JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
    ).to eq true
  end

  it 'Get all contacts (size == 0) (Auth)' do

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