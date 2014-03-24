class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :format_btc, :sort_column, :sort_direction

  def format_btc(btc)
    btc.to_s.rjust(9, '0').insert(-9, '.').sub(/[0]+$/, '').sub(/\.$/, '').rjust(1, '0')
  end

  protected

  def sort_column
    session_field = "#{params[:controller]}_sort".to_s
    sort = params[:sort] || session[session_field] || 'id'
    if sort =~ /^[a-z_]+$/
      session[session_field] = params[:sort] if params[:sort]
      sort
    else
      'id'
    end
  end

  def sort_direction
    session_field = "#{params[:controller]}_direction".to_s
    dir = params[:direction] || session[session_field] || 'desc'
    if %w[asc desc].include?(dir)
      session[session_field] = params[:direction] if params[:direction]
      dir
    else
      'desc'
    end
  end
end
