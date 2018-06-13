require 'rspec'
require 'json'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/json_utilities.rb'
require_relative '../services/auth_service.rb'
require_relative '../services/admin_service.rb'

describe('Portfolios Spec') do

  portfolio_keys = %w[name description resources order id]

  data_req_new_portfolio = {
    name: 'Projecto1',
    description: 'consectetur dolor sit in magna',
    resources: [
      {
        name: 'Recurso1',
        description: 'aliqua in',
        technologies: ['nisi', 'dolore'],
        links: [
          {
            name: 'Link',
            icon: 'fa link',
            link: 'http://www.algo.com/'
          }
        ]
      }
    ],
    order: 1
  }

  data_req_edit_portfolio = {
    name: 'Projecto2',
    description: 'consectetur dolor sit in magna',
    resources: [
      {
        name: 'Recurso2',
        description: 'aliqua in asdgs',
        technologies: ['nisi', 'dolore', 'asdasd'],
        links: [
          {
            name: 'Link1',
            icon: 'fa link',
            link: 'http://www.algo.com/'
          },
          {
            name: 'Link2',
            icon: 'fa link',
            link: 'http://www.algo.com/'
          }
        ]
      }
    ],
    order: 2
  }

  not_found_resp = {
    error: 'Portfolio not found.'
  }

  portfolio_id = ''

  lang = AdminService.random_lang
  path = ''
  base_path = ''

  before(:all) do
    AuthService.login_with_default_user
    path = AdminService.portfolio_path lang
    base_path = AdminService.base_path
  end

  it 'Get all portfolios (size == 0) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 0
  end

  it 'Get all portfolios (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Create a portfolio (Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_portfolio,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_portfolio = data_req_new_portfolio.clone

    portfolio_id = data['id']

    data_res_new_portfolio['id'] = portfolio_id

    data_res_new_portfolio['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_new_portfolio.to_json, data.to_json)

  end

  it 'Get all portfolios (size == 1) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 1

    res['data'].each do |u|
      portfolio_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Create a portfolio (No Auth)' do
    response = ApiRequest.create_post_request(
      base_path,
      path,
      data_req_new_portfolio,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'

  end

  it 'Get a portfolio (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + portfolio_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_new_portfolio = data_req_new_portfolio.clone

    data_res_new_portfolio['id'] = portfolio_id

    data_res_new_portfolio['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_new_portfolio.to_json, data.to_json)
  end

  it 'Get a portfolio (No Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + portfolio_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Edit an portfolio (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + portfolio_id,
      data_req_edit_portfolio,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_portfolio_res = data_req_edit_portfolio.clone

    data_res_edit_portfolio_res['id'] = portfolio_id

    data_res_edit_portfolio_res['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_portfolio_res.to_json, data.to_json)
  end

  it 'Get an edited portfolio (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + portfolio_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    data_res_edit_portfolio_res = data_req_edit_portfolio.clone

    data_res_edit_portfolio_res['id'] = portfolio_id

    data_res_edit_portfolio_res['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_portfolio_res.to_json, data.to_json)
  end

  it 'Get all portfolios (size == 1) (Auth)' do

    response = ApiRequest.create_get_request(
      base_path,
      path,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res['data'].size).to eq 1

    res['data'].each do |u|
      portfolio_keys.each do |k|
        expect(u.has_key? k).to eq true
      end
    end

  end

  it 'Edit an portfolio (No Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + portfolio_id,
      data_req_edit_portfolio,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Get a portfolio (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + portfolio_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 200

    res = JSON.parse(response.body)

    expect(res.has_key?('data')).to eq true

    data = res['data']

    expect(data.has_key?('id')).to eq true

    data_res_edit_portfolio = data_req_edit_portfolio.clone

    data_res_edit_portfolio['id'] = portfolio_id

    data_res_edit_portfolio['lang'] = lang.to_s.upcase

    JsonUtilities.compare_json(data_res_edit_portfolio.to_json, data.to_json)
  end

  it 'Delete an portfolio (No Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + portfolio_id,
      nil
    )

    expect(response.code).to eq 403

    res = JSON.parse(response.body)

    expect(res['message']).to eq 'No token provided.'
  end

  it 'Delete an portfolio (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + portfolio_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 204
  end

  it 'Delete a deleted portfolio (Auth)' do
    response = ApiRequest.create_delete_request(
      base_path,
      path + '/' + portfolio_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Get a deleted portfolio (Auth)' do
    response = ApiRequest.create_get_request(
      base_path,
      path + '/' + portfolio_id,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Edit an deleted portfolio (Auth)' do
    response = ApiRequest.create_put_request(
      base_path,
      path + '/' + portfolio_id,
      data_req_edit_portfolio,
      AuthService.auth_access_token
    )

    expect(response.code).to eq 404

    res = JSON.parse(response.body)

    JsonUtilities.compare_json(not_found_resp.to_json, res.to_json)
  end

  it 'Get all portfolios (size == 0) (Auth)' do

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