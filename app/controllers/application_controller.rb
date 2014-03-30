require 'oauth2'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :format_btc, :sort_column, :sort_direction
  before_filter :last_update

  def format_btc(btc)
    btc.to_s.rjust(9, '0').insert(-9, '.').sub(/[0]+$/, '').sub(/\.$/, '').rjust(1, '0')
  end

  def last_update
    p = Parameter.find_by_key('last_update')
    @last_update = p ? p.value : 'Unknown'
  end

  protected

  def sort_column(model)
    sort = params["#{model}_sort".to_s] || session["#{model}_sort".to_s] || 'id'
    if sort =~ /^[a-z_]+$/
      session["#{model}_sort".to_s] = params["#{model}_sort".to_s] if params["#{model}_sort".to_s]
      sort
    else
      'id'
    end
  end

  def sort_direction(model)
    dir = params["#{model}_direction".to_s] || session["#{model}_direction".to_s] || 'desc'
    if %w[asc desc].include?(dir)
      session["#{model}_direction".to_s] = params["#{model}_direction".to_s] if params["#{model}_direction".to_s]
      dir
    else
      'desc'
    end
  end

  def btcjam_client
    OAuth2::Client.new(OAUTH_CONFIG['jam_id'], OAUTH_CONFIG['jam_secret'], :site => {
        :url=>OAUTH_CONFIG['jam_url'],
        :ssl=>{
            :verify => OpenSSL::SSL::VERIFY_PEER,
            :ca_file => Jammer::Application.config.ca_file
        }
    })
  end
end
