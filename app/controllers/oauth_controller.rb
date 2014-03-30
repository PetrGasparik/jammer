class OauthController < ApplicationController
  def callback
    if params[:error]
      flash[:error] = "Authentication failed with error: #{params[:error]}"

      redirect_to users_path
    else
      case params[:state]
      when 'btcjam'
        client = btcjam_client
        token = client.auth_code.get_token(params[:code], :redirect_uri => OAUTH_CONFIG['callback'])
        response = token.get('/api/v1/me')
        user = User.find(response.parsed['user']['id'])
        user.btcjam_token = client.client_credentials.get_token.token
        user.save!
        redirect_to user_path(user)
      else
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
