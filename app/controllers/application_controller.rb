class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :format_btc, :sort_column, :sort_direction

  def format_btc(btc)
    btc.to_s.rjust(9, '0').insert(-9, '.').sub(/[.0]+$/, '').rjust(1, '0')
  end

  protected

  def sort_column
    params[:sort].to_s =~ /^[a-z_]+$/ ? params[:sort] : 'id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
