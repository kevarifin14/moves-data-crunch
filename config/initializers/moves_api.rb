require 'oauth2'

class MovesApi
  CLIENT =
    OAuth2::Client.new(
      Rails.application.secrets.moves_client_id,
      Rails.application.secrets.moves_secret_id,
      site: 'https://api.moves-app.com/',
      authorize_url: '/oauth/v1/authorize',
      token_url: '/oauth/v1/access_token'
    )
end
