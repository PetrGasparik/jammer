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

    User.all.each do |user|
      active_btc += user.total_debt - user.overdue_btc
      repaid_btc += user.payments_btc
      overdue_btc += user.overdue_btc
    end
    Loan.where(state: 'funding').each do |loan|
      funding_btc += loan.total_to_repay
    end

    render :json => {
        'Repaid BTC' => format_btc(repaid_btc),
        'Active BTC' => format_btc(active_btc),
        'Overdue BTC' => format_btc(overdue_btc),
        'Funding BTC' => format_btc(funding_btc) }
  end

  def loan_stats
    render :json => {
        'Repaid Loans' => Loan.where(state: 'repaid').count,
        'Active Loans' => Loan.where(state: 'active').count,
        'Overdue Loans' => Loan.where(state: 'overdue').count,
        'Funding Loans' => Loan.where(state: 'funding').count }
  end

  def user_stats
    no_loans = 0
    repaid_loans = 0
    active_loans = 0
    overdue_loans = 0

    User.all.each do |user|
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

    User.all.each do |user|
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
