class InvestmentsController < ApplicationController
  before_filter :set_tab

  def index
    user_name_search = "#{params[:user_name]}%"
    loan_name_search = "#{params[:loan_name]}%"
    borrower_name_search = "#{params[:borrower_name]}%"

    @states = {}

    if params[:funding].nil? and params[:overdue].nil? and params[:active].nil? and params[:repaid].nil?
      @states['funding'] = true
      @states['overdue'] = true
      @states['active'] = true
      @states['repaid'] = true
    else
      @states['funding'] = params[:funding] == '1'
      @states['overdue'] = params[:overdue] == '1'
      @states['active'] = params[:active] == '1'
      @states['repaid'] = params[:repaid] == '1'
    end

    per_page = 20

    @period = params[:period] || '3'

    all_investments = Investment.where('user_name LIKE :user_name AND loan_name LIKE :loan_name AND borrower_name LIKE :borrower_name', user_name: user_name_search, loan_name: loan_name_search, borrower_name: borrower_name_search).order("#{sort_column} #{sort_direction}")
    all_investments = all_investments.where('invested_at > :period', period: DateTime.now() - @period.to_i.months) unless @period == 'all'
    all_investments = all_investments.where(state: @states.keys.select{ |k| @states[k] })
    page = [[(all_investments.count.to_f / per_page.to_f).ceil, params[:page].to_i].min, 1].max

    @investments = all_investments.paginate(:page => page, :per_page => per_page)
  end

  private
  def set_tab
    @menu_tab = 'investments'
  end
end
