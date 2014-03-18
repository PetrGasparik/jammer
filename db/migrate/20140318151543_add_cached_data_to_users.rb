class AddCachedDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :loan_count, :integer
    add_column :users, :repaid_btc, :integer, :limit => 8
    add_column :users, :active_btc, :integer, :limit => 8
    add_column :users, :funding_btc, :integer, :limit => 8
    add_column :users, :total_debt, :integer, :limit => 8
    add_column :users, :future_debt, :integer, :limit => 8
    add_column :users, :investments_btc, :integer, :limit => 8
    add_column :users, :active_investments_btc, :integer, :limit => 8
    add_column :users, :overdue_investments_btc, :integer, :limit => 8
    add_column :users, :funding_investments_btc, :integer, :limit => 8
    add_column :users, :repaid_investments_btc, :integer, :limit => 8
    add_column :users, :active_count, :integer
    add_column :users, :repaid_count, :integer
    add_column :users, :funding_count, :integer
    add_column :users, :overdue_loan_count, :integer
    add_column :users, :investments_count, :integer
    add_column :users, :active_investments_count, :integer
    add_column :users, :overdue_investments_count, :integer
    add_column :users, :funding_investments_count, :integer
    add_column :users, :repaid_investments_count, :integer
  end
end
