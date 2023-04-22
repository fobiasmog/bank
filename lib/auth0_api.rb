require 'rest-client'

module Auth0Api
  extend self

  AUTH0_CONFIG = Rails.application.config_for(:auth0)[:api]

  AUTH0_ENDPOINT = AUTH0_CONFIG[:auth0_domain].freeze
  AUTH0_CLIENT_ID = AUTH0_CONFIG[:auth0_client_id].freeze
  AUTH0_CLIENT_SECRET = AUTH0_CONFIG[:auth0_client_secret].freeze
  AUDIENCE = AUTH0_CONFIG[:audience].freeze

  def create_user(name:, email:, password:, connection: 'Username-Password-Authentication')
    body = {
      name: name,
      email: email,
      password: password,
      connection: connection
    }

    post('/users', body)
  end

  private

  def post(path, body)
    RestClient.post("https://#{AUTH0_ENDPOINT}/api/v2#{path}", body.to_json, headers)
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{access_token}"
    }
  end

  def access_token
    response = RestClient.post(
      "https://#{AUTH0_ENDPOINT}/oauth/token",
      {
        grant_type: 'client_credentials',
        client_id: AUTH0_CLIENT_ID,
        client_secret: AUTH0_CLIENT_SECRET,
        audience: AUDIENCE
      }.to_json,
      'Content-Type' => 'application/json'
    )


    JSON.parse(response.body)['access_token']
  end
end
