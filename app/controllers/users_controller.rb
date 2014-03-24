require 'yaml'

class UsersController < ApplicationController
  before_filter :set_tab

  def index
    alias_search = "#{params[:alias]}%"

    per_page = 20

    @period = params[:period] || '3'
    @ratings = params[:rating] || ['A', 'B', 'C', 'D', 'E']
    @columns = params[:columns] || session[:user_columns] || %w(alias profile_link rating total_repayments active_loans funding_loans overdue_payments active_investments approx_debt investment_ratio last_activity)

    @investment_ratio = params[:investment_ratio].to_f if params[:investment_ratio]

    session[:user_columns] = params[:columns] if params[:columns]

    rating_values = []
    rating_values += [14, 13, 12] if @ratings.include? 'A'
    rating_values += [11, 10, 9] if @ratings.include? 'B'
    rating_values += [8, 7, 6] if @ratings.include? 'C'
    rating_values += [5, 4, 3] if @ratings.include? 'D'
    rating_values += [2, 1, 0] if @ratings.include? 'E'

    all_users = User.where("alias LIKE :search", search: alias_search).where(credit_rating: rating_values).order("#{sort_column} #{sort_direction}")
    all_users = all_users.where("funding_count > 0") if params[:only_funding] == '1'
    all_users = all_users.where("investment_ratio >= :ratio", ratio: @investment_ratio) if params[:investment_ratio]
    all_users = all_users.where("last_active_at > :period", period: DateTime.now() - @period.to_i.months) unless @period == 'all'
    page = [[(all_users.count.to_f / per_page.to_f).ceil, params[:page].to_i].min, 1].max

    @users = all_users.paginate(:page => page, :per_page => per_page)
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

  private
  def set_tab
    @menu_tab = 'users'
  end
end
