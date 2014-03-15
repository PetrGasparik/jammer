class ChangeBtcToIntegers < ActiveRecord::Migration
  def change
    change_column :users, :overdue_btc, :integer, :limit => 8
    change_column :users, :payments_btc, :integer, :limit => 8
    change_column :users, :repaid_btc, :integer, :limit => 8
    change_column :users, :active_btc, :integer, :limit => 8

    change_column :loans, :advertised_amount, :integer, :limit => 8
    change_column :loans, :btc_per_payment, :integer, :limit => 8
    change_column :loans, :remaining_fund_amount, :integer, :limit => 8
  end
end
