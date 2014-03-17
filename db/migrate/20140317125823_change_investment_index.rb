class ChangeInvestmentIndex < ActiveRecord::Migration
  def change
    remove_index :investments, [:user_id, :loan_id, :invested_at]
    add_index :investments, [:user_id, :loan_id]
  end
end
