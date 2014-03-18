require 'yaml'

class UsersController < ApplicationController
  def list
    alias_search = "#{params[:alias]}%"

    per_page = 20

    all_users = User.where("alias LIKE :search", search: alias_search).order("#{sort_column} #{sort_direction}")
    page = [[(all_users.count.to_f / per_page.to_f).ceil, params[:page].to_i].min, 1].max

    @users = all_users.paginate(:page => page, :per_page => per_page)
  end

  def export
    unless request.format == 'sql'
      data = User.all.map{ |u| {
          :alias => u.alias,
          :profile => u.profile_url,
          :active_loan_count => u.active_count,
          :active_loan_amount => u.active_btc,
          :repaid_loan_count => u.repaid_count,
          :repaid_loan_amount => u.repaid_btc,
          :overdue_payment_count => u.overdue_count,
          :overdue_payment_amount => u.overdue_btc,
          :repaid_payment_count => u.repaid_count,
          :repaid_payment_amount => u.repaid_btc,
          :approx_total_debt => u.total_debt,
          :approx_future_debt => u.future_debt
      } }
    end

    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.json { render json: data.to_json }
      format.yaml { render text: data.to_yaml, :format => 'text/yaml' }
      format.sql { render text: `mysqldump --single-transaction --add-drop-table -u jammer --password=#{Rails.configuration.database_configuration[Rails.env]['password']} #{Rails.configuration.database_configuration[Rails.env]['database']}`, :format => 'text/sql' }
    end
  end
end
