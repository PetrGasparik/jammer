require 'yaml'

class UsersController < ApplicationController
  before_filter :set_tab

  def index
    alias_search = "#{params[:alias]}%"

    per_page = 20

    @period = params[:period] || '3'
    @ratings = params[:rating] || ['A', 'B', 'C', 'D', 'E']
    @user_columns = params[:columns] || session[:user_columns] || %w(alias rating total_repayments active_loans funding_loans overdue_payments active_investments approx_debt investment_ratio last_activity)

    @investment_ratio = params[:investment_ratio].to_f if params[:investment_ratio]

    session[:user_columns] = params[:columns] if params[:columns]

    rating_values = []
    rating_values += [14, 13, 12] if @ratings.include? 'A'
    rating_values += [11, 10, 9] if @ratings.include? 'B'
    rating_values += [8, 7, 6] if @ratings.include? 'C'
    rating_values += [5, 4, 3] if @ratings.include? 'D'
    rating_values += [2, 1, 0] if @ratings.include? 'E'

    all_users = User.where("alias LIKE :search", search: alias_search).where(credit_rating: rating_values).order("#{sort_column('user')} #{sort_direction('user')}")
    all_users = all_users.where("funding_count > 0") if params[:only_funding] == '1'
    all_users = all_users.where("investment_ratio >= :ratio", ratio: @investment_ratio) if params[:investment_ratio]
    all_users = all_users.where("last_active_at > :period", period: DateTime.now() - @period.to_i.months) unless @period == 'all'
    page = [[(all_users.count.to_f / per_page.to_f).ceil, params[:page].to_i].min, 1].max

    @users = all_users.paginate(:page => page, :per_page => per_page)
  end

  def show
    @user = User.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound if @user.nil?

    per_page = 10

    @loan_columns = params[:loan_columns] || session[:loan_columns] || %w(name user_name loan_link state amount term total_to_repay return apr date)
    loan_page = [[(@user.loans.count.to_f / per_page.to_f).ceil, params[:loan_page].to_i].min, 1].max
    @loans = @user.loans.order("#{sort_column('loan')} #{sort_direction('loan')}").paginate(:page => loan_page, :per_page => per_page)

    investment_page = [[(@user.investments.count.to_f / per_page.to_f).ceil, params[:investment_page].to_i].min, 1].max
    @investments = @user.investments.order("#{sort_column('investment')} #{sort_direction('investment')}").paginate(:page => investment_page, :per_page => per_page)
  end

  def export
    unless request.format == 'sql'
      data = User.includes(:loans).to_a.map do |user|
        user.serializable_hash.merge({ :loans => user.loans.includes(:investments).to_a.map { |loan|
            loan.serializable_hash.merge({ :investments => loan.investments.to_a.map(&:serializable_hash) })
          }
        })
      end
    end

    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.json { render json: data.to_json }
      format.yaml { render text: data.to_yaml, :format => 'text/yaml' }
      format.sql { render text: `mysqldump --single-transaction --add-drop-table -u jammer --password=#{Rails.configuration.database_configuration[Rails.env]['password']} #{Rails.configuration.database_configuration[Rails.env]['database']}`, :format => 'text/sql' }
    end
  end

  def root_redirect
    redirect_to users_url
  end

  def al_chart_data
    user = User.find(params[:user_id])

    data = [
        {name: 'Active', data: {:Investments => format_btc(user.active_investments_btc), :Loans => format_btc(user.active_btc), 'Debt (estimated)' => format_btc([user.total_debt - user.overdue_btc, 0].max)}},
        {name: 'Overdue', data: {:Investments => format_btc(user.overdue_investments_btc), :Loans => format_btc(user.overdue_btc), 'Debt (estimated)' => format_btc(user.overdue_btc > user.total_debt ? user.total_debt : user.overdue_btc)}},
        {name: 'Funding', data: {:Investments => format_btc(user.funding_investments_btc), :Loans => format_btc(user.funding_btc), 'Debt (estimated)' => format_btc(user.future_debt - user.total_debt)}}
    ]

    render :json => data
  end

  def borrowing_chart_data
    user = User.find(params[:user_id])

    data = {
        'Repaid' => format_btc(user.repaid_btc),
        'Active' => format_btc(user.active_btc),
        'Funding' => format_btc(user.funding_btc),
        'Overdue' => format_btc(user.overdue_btc)
    }

    render :json => data
  end

  def lending_chart_data
    user = User.find(params[:user_id])

    data = {
        'Repaid' => format_btc(user.repaid_investments_btc),
        'Active' => format_btc(user.active_investments_btc),
        'Funding' => format_btc(user.funding_investments_btc),
        'Overdue' => format_btc(user.overdue_investments_btc)
    }

    render :json => data
  end

  def authenticate
    client = btcjam_client
    redirect_to client.auth_code.authorize_url(:redirect_uri => OAUTH_CONFIG['callback'], :state => 'btcjam')
  end

  private
  def set_tab
    @menu_tab = 'users'
  end
end
