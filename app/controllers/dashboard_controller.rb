require 'moves'

# Root path which provides navigational options
class DashboardController < ApplicationController
  REDIRECT_URI = 'http://localhost:3000/'

  def show
    if code == 0 and current_user.access_token.nil?
      redirect
    elsif current_user.access_token.nil?
      update_access_token(redirect_access_token.token)
    end
    @moves_client = moves_client
  end

  private

  def client
    MovesApi::CLIENT
  end

  def moves_client
    Moves::Client.new(current_user.access_token)
  end

  def update_access_token(token)
    current_user.update!(access_token: token)
  end

  def redirect
    redirect_to client.auth_code.authorize_url(
      redirect_uri: REDIRECT_URI,
      scope: 'activity location',
    )
  end

  def redirect_access_token
    client.auth_code.get_token(
      code,
      redirect_uri: REDIRECT_URI,
      headers: { grant_type: 'authorization_code' },
    )
  end

  def code
    params.fetch(:code, 0)
  end
end
