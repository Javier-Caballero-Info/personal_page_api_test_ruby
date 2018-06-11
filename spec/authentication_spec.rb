require 'rspec'
require_relative '../utils/rest_client_library.rb'
require_relative '../utils/awt_library.rb'

describe('Auth Spec') do

  new_credentials = {
    password: 'new_password',
    password_confirmation: 'new_password'
  }

  old_credentials = {
    password: ENV['RIGHT_PASSWORD'],
    password_confirmation: ENV['RIGHT_PASSWORD']
  }

  it 'Correct login' do
    response = create_post_request('/v1/session', right_credentials, nil)

    expect(response.code).to eq 201

    res = JSON.parse(response.body)

    expect(res['access_token'].to_s.split('.').size).to be 3
    expect(res['refresh_token'].to_s.split('.').size).to be 3
    expect(res['message']).to eq 'Logged in as caballerojavier13'
    expect(validate_awt_token(res['access_token'])).to eq true
    expect(validate_awt_token(res['refresh_token'])).to eq true
  end

  it 'Invalid credentials' do
    response = create_post_request('/v1/session', wrong_credentials, nil)

    expect(response.code).to eq 400

    res = JSON.parse(response.body)

    expect(res['code']).to be 400
    expect(res['message']).to eq 'Wrong credentials'
    expect(res['type']).to eq 'BAD_REQUEST'
  end

  it 'Invalid request' do
    response = create_post_request('/v1/session', {}, nil)

    expect(response.code).to eq 400

    res = JSON.parse(response.body)

    expect(res['code']).to be 400
    expect(res['message']).to eq 'Wrong credentials'
    expect(res['type']).to eq 'BAD_REQUEST'
  end

  it 'Refresh token' do
    login_with_default_user

    response = create_put_request('/v1/session', {}, @auth_refresh_token)

    res = JSON.parse(response.body)

    expect(response.code).to eq 200

    expect(res['access_token'].to_s.split('.').size).to be 3
    expect(res['message']).to eq 'Logged in as caballerojavier13'
    expect(validate_awt_token(res['access_token'])).to eq true
  end

  it 'Change password' do
    login_with_default_user

    response = login_with_default_user

    expect(response.code).to eq 201

    response = create_put_request('/v1/password', new_credentials, @auth_access_token)

    expect(response.code).to eq 204

    response = login_with_default_user

    expect(response.code).to eq 400

    response = create_put_request('/v1/password', old_credentials, @auth_access_token)

    expect(response.code).to eq 204
  end

end