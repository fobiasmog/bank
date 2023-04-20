class Auth0Controller < ApplicationController
  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this code, you will pull the raw_info supplied from the id_token and assign it to the session.
    # Refer to https://github.com/auth0/omniauth-auth0/blob/master/EXAMPLES.md#example-of-the-resulting-authentication-hash for complete information on 'omniauth.auth' contents.
    auth_info = request.env['omniauth.auth']
    session[:userinfo] = auth_info['extra']['raw_info']

    user_hash = {
      email: auth_info.dig('extra', 'raw_info', 'email'),
      name: auth_info.dig('extra', 'raw_info', 'nickname'),
      avatar_url: auth_info.dig('extra', 'raw_info', 'picture'),
    }

    Auth::CreateUserInteractor.run!(**user_hash)

    # Redirect to the URL you want after successful auth
    redirect_to '/'
  end

  def failure
    # Handles failed authentication -- Show a failure page (you can also handle with a redirect)
    @error_msg = request.params['message']
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: AUTH0_CONFIG['auth0_client_id']
    }

    URI::HTTPS.build(host: AUTH0_CONFIG['auth0_domain'], path: '/v2/logout', query: request_params.to_query).to_s
  end
end



# {
#   "provider"=>"auth0",
#   "uid"=>"auth0|644039a34e4a6dfdf3715355",
#   "info"=> {
#     "name"=>"test1@test.com",
#     "nickname"=>"test1",
#     "email"=>nil,
#     "image"=>"https://s.gravatar.com/avatar/94fba03762323f286d7c3ca9e001c541?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fte.png"
#   },
#   "credentials"=> {
#     "token"=> "..."
#     "expires_at"=>1682017065,
#     "expires"=>true,
#     "id_token"=> "..."
#     "token_type"=>"Bearer",
#     "refresh_token"=>nil
#   },
#   "extra" => {
#     "raw_info"=> {
#       "nickname"=>"test1",
#       "name"=>"test1@test.com",
#       "picture"=>"https://s.gravatar.com/avatar/94fba03762323f286d7c3ca9e001c541?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fte.png",
#       "updated_at"=>"2023-04-19T18:57:39.514Z",
#       "iss"=>"https://dev-qb6dszkhq6iinvq2.us.auth0.com/",
#       "aud"=>"Z1QjSCeBkDdxapP8lRpq1Lyew63peHux",
#       "iat"=>1681930665,
#       "exp"=>1681966665,
#       "sub"=>"auth0|644039a34e4a6dfdf3715355",
#       "sid"=>"vXaLQ491Uy-E44TxFOiUNSqkshFpJLxb",
#       "nonce"=>"0682fb070802636929c3013848cd8735"
#     }
#   }
# }