class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :format_btc, :sort_column, :sort_direction

  def format_btc(btc)
    btc.to_s.rjust(9, '0').insert(-9, '.').sub(/[0]+$/, '').sub(/\.$/, '').rjust(1, '0')
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
end
