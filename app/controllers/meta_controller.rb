class MetaController < ApplicationController
  def stats
    @menu_tab = 'stats'
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
      user.loans.find_all_by_state('funding').each do |loan|
        funding_btc += loan.total_to_repay
      end
    end

    render :json => {
        'Repaid BTC' => repaid_btc,
        'Active BTC' => active_btc,
        'Overdue BTC' => overdue_btc,
        'Funding BTC' => funding_btc }
  end

  def loan_stats
    render :json => {
        'Repaid Loans' => Loan.find_all_by_state('repaid').count,
        'Active Loans' => Loan.find_all_by_state('active').count,
        'Overdue Loans' => Loan.find_all_by_state('overdue').count,
        'Funding Loans' => Loan.find_all_by_state('funding').count }
  end
end
