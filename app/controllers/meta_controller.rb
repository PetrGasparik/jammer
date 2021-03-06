class MetaController < ApplicationController
  def stats
    @menu_tab = 'stats'
  end

  def faq
    @menu_tab = 'faq'
  end

  def todo
    @menu_tab = 'todo'
  end

  def btc_stats
    active_btc = 0
    repaid_btc = 0
    overdue_btc = 0
    funding_btc = 0

    months = case params[:period].to_i
      when 6
        6
      when 12
        12
      else
        9999
    end

    User.where('last_active_at >= ?', DateTime.now - months.months).each do |user|
      active_btc += user.total_debt - user.overdue_btc
      repaid_btc += user.payments_btc
      overdue_btc += user.overdue_btc
    end
    Loan.where(state: 'funding').where('invested_at >= ?', DateTime.now - months.months).each do |loan|
      funding_btc += loan.total_to_repay
    end

    render :json => {
        'Repaid BTC' => format_btc(repaid_btc),
        'Active BTC' => format_btc(active_btc),
        'Overdue BTC' => format_btc(overdue_btc),
        'Funding BTC' => format_btc(funding_btc) }
  end

  def loan_stats
    months = case params[:period].to_i
    when 6
      6
    when 12
      12
    else
      9999
    end

    render :json => {
        'Repaid Loans' => Loan.where(state: 'repaid').where('invested_at >= ?', DateTime.now - months.months).count,
        'Active Loans' => Loan.where(state: 'active').where('invested_at >= ?', DateTime.now - months.months).count,
        'Overdue Loans' => Loan.where(state: 'overdue').where('invested_at >= ?', DateTime.now - months.months).count,
        'Funding Loans' => Loan.where(state: 'funding').where('invested_at >= ?', DateTime.now - months.months).count }
  end

  def user_stats
    no_loans = 0
    repaid_loans = 0
    active_loans = 0
    overdue_loans = 0

    months = case params[:period].to_i
    when 6
      6
    when 12
      12
    else
      9999
    end

    User.where('last_active_at >= ?', DateTime.now - months.months).each do |user|
      if user.loans.select{ |loan| loan.state == 'overdue' }.count > 0
        overdue_loans += 1
      elsif user.loans.select{ |loan| loan.state == 'active' }.count > 0
        active_loans += 1
      elsif user.loans.select{ |loan| loan.state == 'repaid' }.count > 0
        repaid_loans += 1
      else
        no_loans += 1
      end
    end

    render :json => {
        'Have repaid all loans' => repaid_loans,
        'Have active but not overdue loans' => active_loans,
        'Have overdue loans' => overdue_loans,
        'Have never taken out a loan' => no_loans}
  end

  def borrower_stats
    repaid_loans = 0
    active_loans = 0
    overdue_loans = 0

    months = case params[:period].to_i
    when 6
      6
    when 12
      12
    else
      9999
    end

    User.where('last_active_at >= ?', DateTime.now - months.months).each do |user|
      if user.loans.select{ |loan| loan.state == 'overdue' }.count > 0
        overdue_loans += 1
      elsif user.loans.select{ |loan| loan.state == 'active' }.count > 0
        active_loans += 1
      elsif user.loans.select{ |loan| loan.state == 'repaid' }.count > 0
        repaid_loans += 1
      end
    end

    render :json => {
        'Have repaid all loans' => repaid_loans,
        'Have active but not overdue loans' => active_loans,
        'Have overdue loans' => overdue_loans }
  end
end
