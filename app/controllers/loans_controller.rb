class LoansController < ApplicationController
  before_filter :set_tab

  def index
    name_search = "#{params[:name]}%"

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

    all_loans = Loan.where("name LIKE :search", search: name_search).order("#{sort_column} #{sort_direction}")
    all_loans = all_loans.where("invested_at > :period", period: DateTime.now() - @period.to_i.months) unless @period == 'all'
    all_loans = all_loans.where(state: @states.keys.select{ |k| @states[k] })
    page = [[(all_loans.count.to_f / per_page.to_f).ceil, params[:page].to_i].min, 1].max

    @loans = all_loans.paginate(:page => page, :per_page => per_page)
  end

  private
  def set_tab
    @menu_tab = 'loans'
  end
end
