class AddBtcPaymentInfoToUsers < ActiveRecord::Migration
  def change
    add_column(:users, :payments_count, :integer)
    add_column(:users, :payments_btc, :float)

    add_column(:users, :active_count, :integer)
    add_column(:users, :active_btc, :float)

    add_column(:users, :repaid_count, :integer)
    add_column(:users, :repaid_btc, :float)

    add_column(:users, :funding_count, :integer)
    add_column(:users, :funding_btc, :float)

    add_column(:users, :overdue_count, :integer)
    add_column(:users, :overdue_btc, :float)
  end
end
