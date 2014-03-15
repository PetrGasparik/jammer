require 'yaml'

class UsersController < ApplicationController
  def list
    alias_search = "#{params[:alias]}%"

    @users = User.where("alias LIKE :search", search: alias_search).order('id desc').paginate(:page => params[:page], :per_page => 20)
  end

  def export
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

    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.json { render json: data.to_json }
      format.yaml { render text: data.to_yaml, :format => 'text/yaml' }
    end
  end
end
